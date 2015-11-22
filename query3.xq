for $mgrhist in doc("v-depts.xml")/departments/department/mgrno
    let $dept := $mgrhist/..                                     
    where not(xs:date($mgrhist/@tstart) > xs:date("1996-05-06")
        or xs:date("1994-05-01") > xs:date($mgrhist/@tend))     
return <depthist>
        {$dept/deptno}
        {$dept/deptname}
        {$mgrhist}
      </depthist>

