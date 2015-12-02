for $emp in doc("v-emps.xml")/employees/employee
	where $emp/firstname="Anneke" and $emp/lastname="Preusig"
return $emp/salary
