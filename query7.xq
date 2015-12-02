declare variable $vemps := doc("v-emps.xml");

for $salperiod in
    (for $sal in 
        (<allmax>
        {for $oneperiod in 
            (for $onetstart in (
                <alltime>{
                for $onetime in distinct-values
                    (for $onesal in 
                        (
                        for $deptno in $vemps/employees/employee/deptno
                            let $emp := $deptno/..
                            where $deptno = "d005" 
                        return 
                                 (for $sal in $emp/salary
                                    let $maxstart := max((xs:date(data($sal/@tstart)), xs:date(data($deptno/@tstart))))
                                    let $minend := min((xs:date(data($sal/@tend)), xs:date(data($deptno/@tend))))
                                    where not ((xs:date(data($sal/@tstart)) > xs:date(data($deptno/@tend)) or xs:date(data($sal/@tend)) < xs:date(data($deptno/@tstart))))
                                    return <salhist value="{$sal/text()}" tstart="{$maxstart}" tend="{$minend}"/>)
                        )
                        let $tstart := data($onesal/@tstart), $tend := data($onesal/@tend)
                    return ($tstart, $tend))
                    order by xs:date($onetime) ascending
                return <time>{$onetime}</time>
                }</alltime>)//time
                let $onetend := $onetstart/following-sibling::time[1]
                where not(empty($onetend))
            return <period><start>{$onetstart}</start><end>{$onetend}</end></period>)
        let $empsal := (for $oneempsal in 
                        (
            for $deptno in $vemps/employees/employee/deptno
                let $emp := $deptno/..
                where $deptno = "d005" 
            return 
                     (for $sal in $emp/salary
                        let $maxstart := max((xs:date(data($sal/@tstart)), xs:date(data($deptno/@tstart))))
                        let $minend := min((xs:date(data($sal/@tend)), xs:date(data($deptno/@tend))))
                        where not ((xs:date(data($sal/@tstart)) > xs:date(data($deptno/@tend)) or xs:date(data($sal/@tend)) < xs:date(data($deptno/@tstart))))
                        return <salhist value="{$sal/text()}" tstart="{$maxstart}" tend="{$minend}"/>)
                )
                    where not(xs:date($oneempsal/@tstart) >= xs:date($oneperiod/end/time) or xs:date($oneempsal/@tend) <= xs:date($oneperiod/start/time))  
                    return xs:integer($oneempsal/@value))
        return <maxsalary 
                    tend="{$oneperiod/end}"
                    tstart="{$oneperiod/start}"
                >
                    {max($empsal)}
                </maxsalary>
        }</allmax>)//maxsalary
        let $sal_follow := $sal/following-sibling::*,
            $sal_preceding := $sal/preceding-sibling::*[1]
        where not(not(empty($sal_preceding)) and $sal_preceding/text() = $sal/text())
    return <sal>
            {$sal}
            {for $one_follow in $sal_follow           
                where $one_follow/text() = $sal/text()
                return $one_follow}                   
            </sal>
    )
    let $salstart := data($salperiod/maxsalary[1]/@tstart),
        $salend := data($salperiod/maxsalary[last()]/@tend)
return <maxperiod tstart="{$salstart}" tend="{$salend}">{$salperiod/maxsalary[1]/text()}</maxperiod>



