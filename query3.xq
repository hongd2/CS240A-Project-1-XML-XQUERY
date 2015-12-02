for $dept in doc("v-depts.xml")/departments/department
return <depthist>                                     
        {$dept/deptno}                                
        {$dept/deptname}                              
        {
            for $mgrhist in $dept/mgrno
                let $maxstart := max(( xs:date(data($mgrhist/@tstart)), xs:date("1994-05-01")))
                let $minend   := min(( xs:date(data($mgrhist/@tend)), xs:date("1996-05-06")))
                where not(xs:date(data($mgrhist/@tstart)) > xs:date("1996-05-06")
                    or xs:date(data($mgrhist/@tend)) < xs:date("1994-05-01"))
            return <mgrno tstart="{$maxstart}"
		                    tend="{$minend}">
                    {$mgrhist/text()}</mgrno>
        }                                    
      </depthist>  
