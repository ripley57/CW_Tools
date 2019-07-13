package com.manning.chapter2

Expando smartIterator = new Expando()

// Creating a field to hold next number.
smartIterator.counter = 0;

// Creating a field to hold max value.
smartIterator.limit = 4;

// Imitation of iterator iterface.
smartIterator.hasNext = { return counter < limit}
smartIterator.next = {return counter++}

// Adding custom method not defined in iterator interface.
smartIterator.restartFrom = {from->counter = from}

// Using the Expando in the place of an iterator.
for(Integer number:smartIterator as Iterator<Integer>)
{
	println "Next number is $number"
}

// Calling our reset method.
println "Reset smart iterator"
smartIterator.restartFrom(2)

// Using the Expando after resetting it.
for(Integer number:smartIterator as Iterator<Integer>)
{
	println "Next number is $number"
}
