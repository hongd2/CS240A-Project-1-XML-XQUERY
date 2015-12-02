declare variable $vemps := doc("v-emps.xml");

for $jobtitle in distinct-values($vemps/employees/employee/title)
    return <jobtitle value="{$jobtitle}">{
        for $onetstart in 
                (<alltime>{for $onetime in distinct-values
                (for $emptitle in $vemps/employees/employee/title
                let $emp := $emptitle/..
                where $emptitle/text() = $jobtitle
                return (
                    for $empsal in $emp/salary
                    let $maxstart := max(( xs:date(data($empsal/@tstart)), xs:date(data($emptitle/@tstart))))
                    let $minend := min(( xs:date(data($emptitle/@tend)), xs:date(data($empsal/@tend))))
                    where not(xs:date(data($empsal/@tstart)) >= xs:date(data($emptitle/@tend)) or xs:date(data($empsal/@tend)) <= xs:date(data($emptitle/@tstart)))
                    return ($maxstart, $minend)
                ))
                order by xs:date($onetime) ascending
            return <time>{$onetime}</time>}</alltime>)//time
            let $onetend := $onetstart/following-sibling::time[1]
            where not(empty($onetend))
            return <period start="{$onetstart}" end="{$onetend}">
                    <average>
                    { 
                        avg
                        (for $emptitle in $vemps/employees/employee/title
                            let $emp := $emptitle/..
                            where $emptitle/text() = $jobtitle
                            return (
                                for $empsal in $emp/salary
                                where not(xs:date(data($empsal/@tstart)) >= xs:date(data($emptitle/@tend)) or xs:date(data($empsal/@tend)) <= xs:date(data($emptitle/@tstart)))
                                  and not(xs:date(data($empsal/@tstart)) >= xs:date($onetend) or xs:date(data($empsal/@tend)) <= xs:date($onetstart))                            
                                return $empsal/text()
                            ))
                    }
                    </average>
                </period>

    }</jobtitle>
