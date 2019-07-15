package com.manning.chapter4.structure

import spock.lang.*

import com.manning.chapter4.Product

class FailureRenderingSpec extends spock.lang.Specification{

	def "Adding products to a basket increases its weight"() {
		given: "an empty basket"
		ProblematicBasket basket = new ProblematicBasket()
		
		and: "two different products"
		Product laptop = new Product(name:"toshiba",price:1200,weight:5)
		Product camera = new Product(name:"panasonic",price:350,weight:2)

		when: "user gets a laptop and two cameras"
		basket.addProduct(camera,2)
		basket.addProduct(laptop)

		then: "basket weight is updated accordingly"
		basket.currentWeight == (2 * camera.weight) + laptop.weight
	}
	
	def "Adding products to a basket increases its weight (alt)"() {
		given: "an empty basket"
		ProblematicBasket basket = new ProblematicBasket()
		
		and: "a camera product"
		Product camera = new Product(name:"panasonic",price:350,weight:2)

		when: "user gets two cameras"
		basket.addProduct(camera,2)

		then: "basket weight is updated accordingly"
		// JUnit-style assert (not as useful as the Spock/Groovy assert above).
		assert basket.currentWeight == (2 * camera.weight) ,"Use case UC05 does not pass (critical)"
	}
}

