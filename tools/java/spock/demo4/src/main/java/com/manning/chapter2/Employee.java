package com.manning.chapter2;

/*
** NOTE: Only the implicit empty-args constructor is created here, but with Groovy
**       our Spock test can initialise all the fields in one go using this !!:
** 	
**	 Employee trainee = new Employee(age:22,firstName:"Alice",lastName:"Olson",inTraining:true)
**
** NOTE: For this to work, our Employee class *does* require that we explicitly define
**       getters and setters. For example, comment-out "setFirstName()" belowand the Spock
**	 tests in ObjectCreationSpec.groovy will fail.
*/

public class Employee {
	private String firstName;
	private String middleName;
	private String lastName;

	private boolean retired;
	private boolean inTraining;

	private int age;

	public String getFirstName() {
		return firstName;
	}
	public void setFirstName(String firstName) {
		this.firstName = firstName;
	}

	public String getMiddleName() {
		return middleName;
	}
	public void setMiddleName(String middleName) {
		this.middleName = middleName;
	}

	public String getLastName() {
		return lastName;
	}
	public void setLastName(String lastName) {
		this.lastName = lastName;
	}

	public boolean isRetired() {
		return retired;
	}
	public void setRetired(boolean retired) {
		this.retired = retired;
	}

	public boolean isInTraining() {
		return inTraining;
	}
	public void setInTraining(boolean inTraining) {
		this.inTraining = inTraining;
	}

	public int getAge() {
		return age;
	}
	public void setAge(int age) {
		this.age = age;
	}
}
