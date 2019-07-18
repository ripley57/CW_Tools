package com.manning.spock;

import geb.Browser
import geb.spock.GebSpec
import spock.lang.*

/**
 * Trivial Geb test
 * @author Kostis
 *
 */
class HomePageSpec extends GebSpec {

	def "Trivial Geb test for homepage"() {
		when: "I go to homepage"
		Browser.drive {
			go "/web-ui-example/index.html"
		}
		
		then: "First page should load"
		// make sure we actually got to the page
		// by checking the <title> html value:
		title == "Spock/Geb Web example"
		
	}
	
	def "Trivial Geb test for homepage -header check"() {
		when: "I go to homepage"
		Browser.drive {
			go "/web-ui-example/index.html"
		}
		
		then: "First page should load"
		title == "Spock/Geb Web example"
		// Verify h1 html tag content:
		$("h1").text() == "Java Testing with Spock - Sample code"
		// Verify that the "Welcome" tab is active: 
		$(".active").text() == "Welcome"
	}
}
