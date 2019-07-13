package com.manning.chapter2

println "Executing ..."

/*
** Maps - creating
*/

// Creating a map, in Java code:
Map<String,Integer> wordCounts = new HashMap<>();
wordCounts.put("Hello",1);
wordCounts.put("Java",1);
wordCounts.put("World",2);

// Creating a map, in Groovy code:
Map<String,Integer> wordCounts2 = ["Hello":1,"Groovy":1,"World":2]

// Create objects, in Groovy code:
// NOTE: setters are required in the classes.
Employee person1 = new Employee(firstName:"Alice",lastName:"Olson",age:30)
Employee person2 = new Employee(firstName:"Jones",lastName:"Corwin",age:45)
Address address1 = new Address(street:"Marley",number:25)
Address address2 = new Address(street:"Barnam",number:7)

// Add objects to map, in Java code:
Map<Employee,Address> staffAddresses = new HashMap<>();
staffAddresses.put(person1, address1);
staffAddresses.put(person2, address2);

// Add objects to map, in Groovy code:
//
// NOTE: The extra parentheses are required around the objects being
//       used as keys, otherwise they are treated as string values!
//
Map<Employee,Address> staffAddresses2 = [(person1):address1,(person2):address2]

assert staffAddresses[person2].street == "Barnam"


//
// Lists & Arrays - creating
//
// Because the syntax of arrays and lists is similar in Groovy, you might
// find yourself using arrays less as you gain experience with Groovy.
//

// Create a list, in Java code:
List<String> races = Arrays.asList("Drazi", "Minbari", "Humans")

// Create a list, in Groovy code:
List<String> races2 = ["Drazi", "Minbari", "Humans"]

assert races == races2

// Create an array, in Groovy code:
String[] racesArray = ["Drazi", "Minbari", "Humans"]

// !!!! NOTE !!!!
// The following is valid Java, but invalid Groovy:
//String[] racesArrayJava = {"Drazi", "Minbari", "Humans"}

assert racesArray[0] == "Drazi"
assert races[0] == "Drazi"
assert racesArray.size() == races2.size()


/*
** Lists - accessing
*/

// Create a list, in Groovy code:
List<String> humanShips = ["Condor","Explorer"]

// Java code:
assert humanShips.get(0) == "Condor"
// Groovy code:
assert humanShips[0] == "Condor"

// Java code:
humanShips.add("Hyperion")
// Groovy code:
humanShips << "Nova" << "Olympus"
assert humanShips[3] == "Nova"
assert humanShips[4] == "Olympus"
humanShips[3] = "Omega"
assert humanShips[3] == "Omega"

// Using an non-existing index.
// Groovy code.
humanShips[8] = "Warlock"
assert humanShips[8] == "Warlock"
assert humanShips[7] == null


/*
** Maps - accessing
*/

// Create empty map, in Groovy code:
Map<String,String> personRoles = [:]

// Java code:
personRoles.put("Suzan Ivanova","Lt. Commander")
// Groovy code:
personRoles["Stephen Franklin"]= "Doctor"

// Java accessing map:
assert personRoles.get("Suzan Ivanova") == "Lt. Commander"
// Groovy accessing map:
assert personRoles["Stephen Franklin"] == "Doctor"

// Groovy replacing element:
personRoles["Suzan Ivanova"]= "Commander"
assert personRoles["Suzan Ivanova"] == "Commander"

