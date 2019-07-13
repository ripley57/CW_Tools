package com.manning.spock.chapter2

import java.util.regex.Pattern

//This script should run without errors because all asserts evaluate to true

assert true
assert !false

// Boolean variables work like Java
assert true || false 
assert true && !false

// A non-empty string is true
String firstName = "Susan"
assert firstName
def lastName = "Ivanova"
assert lastName

// An empty string is false
String empty = ""
assert !empty 

// A valid reference is true
class Person {
}
Person person = new Person()
assert person;

// A null reference is false
Person nullReference = null
assert !nullReference;

// A non-zero number is true
int answerToEverything = 42
assert answerToEverything

// A zero number if false
int zero=0
assert !zero

// A non-empty collection is true
Object[] array= new Object[3];
assert array 

// An empty collection is false
Object[] emptyArray= new Object[0];
assert !emptyArray 

// Regex is true if it matches
Pattern myRegex = ~/needle/
assert myRegex.matcher("needle in haystack")
assert !myRegex.matcher("Wrong haystack")
//Regular expression shortcut with the =~ operator
assert "needle in haystack" =~/needle/
assert !("Wrong haystack" =~/needle/)

// All closures are assumed to be "true"
def closure = { number -> number+2 }
assert closure

/*
 * Fun with Groovy truth 
 * 
 * Note: This is valid Groovy code: boolean flag = -45. 
 * Even though this line does not even compile in Java, 
 * in Groovy the number -45 is a non-zero number and therefore 
 * the variable flag is now true. Isn't that fun?
 */
boolean flag = -42
assert flag

println "Script has finished because all asserts pass"
