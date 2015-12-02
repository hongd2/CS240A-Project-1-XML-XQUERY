declare variable $vemps := doc("v-emps.xml");

for $oneperiodhist in
	for $onetstart in(
		<alltime>{
		for $onetime in distinct-values
			(for $onesal in $vemps/employees/employee/salary
				let $tstart :=data($onesal/@tstart), $tend := data($onesal/@tend)
			return ($tstart, $tend))
			order by xs:date($onetime) ascending
		return <time>{$onetime}</time>
		}</alltime>)//time
		let $onetend := $onetstart/following-sibling::time[1]
		where not(empty($onetend))
	return <period><start>{$onetstart}</start><end>{$onetend}</end></period>
	let $empsal := for $sal in $vemps/employees/employee/salary
				    where not(xs:date($sal/@tstart) >= xs:date($oneperiodhist/end/time/text()) or
	                        xs:date($sal/@tend) <= xs:date($oneperiodhist/start/time/text()))
					return $sal
return <avgsalperiod salary="{avg($empsal)}" tstart="{$oneperiodhist/start/time/text()}" tend="{$oneperiodhist/end/time/text()}"/>
