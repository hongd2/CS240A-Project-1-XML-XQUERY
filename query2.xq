for $sal in doc("v-emps.xml")/employees/employee/salary
    let $emp:=$sal/..
    where xs:date($sal/@tend) > xs:date("1995-01-01") 
      and xs:date("1995-01-01") > xs:date($sal/@tstart)
      and $sal > 80000
    return <highsal name="{$emp/firstname}" value="{$sal}" deptno="{$emp/deptno}"/>

