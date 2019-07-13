package com.manning.chapter2

class SimpleEmployee
{
	String fullName
	int age
	SimpleDepartment department
	
}
class SimpleDepartment {
	String name;
	String location;
}

// Groovy code:
SimpleDepartment sales = new SimpleDepartment(name:"Sales",location:"block C")
SimpleEmployee employee = new SimpleEmployee(fullName:"Andrew Collins",age:37,department:sales)

// Java code:
System.out.println("Age is "+employee.getAge())
// Groovy code:
println "Age is $employee.age"

// Java code:
System.out.println("Department location is at "+employee.getDepartment().getLocation())
// Groovy code:
println "Department location is at $employee.department.location"

// Groovy code, evaluate expression:
println "Person is adult ${employee.age > 18}"

// Groovy code, escape $ sign:
println "Amount in dollars is \$300"

// Groovy code, do NOT evaluate anything:
println 'Person is adult ${employee.age > 18}'


// Groovy code, multi-line string:
String input = '''I want you to know you were right. I didn't want \
to admit that. Just pride I guess. You get my age, you \
get kinda set in your ways. It had to be \
Creation of a done. Don't blame yourself for what happened later.'''
println "$input"

