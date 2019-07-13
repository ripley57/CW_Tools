package com.manning.chapter2

import groovy.json.JsonSlurper

Closure simple = { int x -> return x * 2}
assert simple(3) == 6

// Same as above, but more concise.
def simpler = { x -> x * 2}
assert simpler(3) == 6

// Close with two arguments.
def twoArguments = { x,y -> x + y}
assert twoArguments(3,5) ==8

