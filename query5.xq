declare variable $vemps := doc("v-emps.xml");
declare variable $vdepts := doc("v-depts.xml");

for $emp in $vemps/employees/employee
return <longtermemp>
        {$emp/empno}
		{for $empmgrhist in (for $dept_period in $emp/deptno,
									$mgr_period in
							        (for $manager_period in $vdepts/departments/department/mgrno
							            let $deptno := $manager_period/../deptno
							        return <manager_period mgrno="{$manager_period/text()}"
											                tstart="{$manager_period/@tstart}"
											                tend="{$manager_period/@tend}"
											                deptno="{$deptno/text()}"/>
							        )
						        let $maxstart := max((xs:date(data($dept_period/@tstart)), xs:date(data($mgr_period/@tstart))))
						        let $minend := min((xs:date(data($dept_period/@tend)), xs:date(data($mgr_period/@tend))))
								where not(xs:date(data($mgr_period/@tstart)) > xs:date(data($dept_period/@tend)) or xs:date(data($mgr_period/@tend)) < xs:date(data($dept_period/@tstart)))
						            and data($mgr_period/@deptno) = $dept_period/text()
					        return <empmgr mgrno="{$mgr_period/@mgrno}"
							                deptno="{$mgr_period/@deptno}"
							                tstart="{$maxstart}"
							                tend="{$minend}"/>
					        )
            let $maxmgr := max
                (for $dept_period in $emp/deptno,
	                $mgr_period in
					(for $manager_period in $vdepts/departments/department/mgrno
					    let $deptno := $manager_period/../deptno
					return <manager_period mgrno="{$manager_period/text()}"
					                        tstart="{$manager_period/@tstart}"
					                        tend="{$manager_period/@tend}"
					                        deptno="{$deptno/text()}"/>
	                )
                let $maxstart := max((xs:date(data($mgr_period/@tstart)), xs:date(data($dept_period/@tstart))))
                let $minend   := min((xs:date(data($mgr_period/@tend)), xs:date(data($dept_period/@tend))))
                where not(xs:date(data($mgr_period/@tstart)) > xs:date(data($dept_period/@tend)) or xs:date(data($mgr_period/@tend)) < xs:date(data($dept_period/@tstart)))
                    and data($mgr_period/@deptno) = $dept_period/text()
                return $minend - $maxstart
                )
            where xs:date(data($empmgrhist/@tend)) - xs:date(data($empmgrhist/@tstart)) = $maxmgr
        return $empmgrhist
    }
    </longtermemp>

