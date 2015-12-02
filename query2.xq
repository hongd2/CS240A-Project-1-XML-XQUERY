for $sal in doc("v-emps.xml")/employees/employee/salary
    let $emp:=$sal/..
    where xs:date($sal/@tend) > xs:date("1995-01-01") 
      and xs:date($sal/@tstart) < xs:date("1995-01-01")
      and $sal > 80000
    return <highsalary firstname="{$emp/firstname}" 
						lastname="{$emp/lastname}" 
						value="{$sal}" 
						deptno="{for $deptno in $emp/deptno
				                    where xs:date(data($deptno/@tend)) > xs:date("1995-01-01")  
							        and xs:date(data($deptno/@tstart)) < xs:date("1995-01-01") 
				                return $deptno/text()}">
            </highsalary>
