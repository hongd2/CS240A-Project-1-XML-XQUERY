for $emp in doc("v-emps.xml")/employees/employee
    let $max_period := max
        (
			for $sal in $emp/salary
			    let $salperiod := min((current-date(), xs:date(data($sal/@tend)))) - xs:date(data($sal/@tstart))
			return $salperiod
        )
return <newemp>                                                                      
            {$emp/firstname}
            {$emp/lastname}
        {
			for $sal in $emp/salary                                                     
			    let $salperiod := min((current-date(), xs:date(data($sal/@tend)))) - xs:date(data($sal/@tstart))
		        where $salperiod = $max_period
            return <salary tstart="{$sal/@tstart}"
							tend="{min((current-date(), xs:date(data($sal/@tend))))}"> 
							{$sal/text()}
					</salary>              
        }                                                                            
        </newemp>                                                                    
