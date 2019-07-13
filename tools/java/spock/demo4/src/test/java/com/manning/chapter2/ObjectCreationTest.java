package com.manning.chapter2;

import static org.junit.Assert.assertEquals;

import java.util.Arrays;
import java.util.List;

import org.junit.Test;
import org.junit.Ignore;

/*
** Remove @Ignore to run the test(s).
*/
//@Ignore
public class ObjectCreationTest {

	@Test
	//@Ignore
	public void recentHires()
	{
		Employee trainee = new Employee();
		trainee.setAge(22);
		trainee.setFirstName("Alice");
		trainee.setLastName("Olson");
		trainee.setInTraining(true);
		
		Employee seasoned = new Employee();
		seasoned.setAge(45);
		seasoned.setFirstName("Alex");
		seasoned.setMiddleName("Jones");
		seasoned.setLastName("Corwin");
		
		List<Employee> people = Arrays.asList(trainee,seasoned);
		
		Department department = new Department();
		department.assign(people);
		
		assertEquals("Expected two employees",department.manpowerCount(),2);
	}
}
