package com.manning.chapter4.blocks

import spock.lang.*

import com.manning.chapter4.Basket
import com.manning.chapter4.Product

/*
* This class demonstrates how to use the "given:", "when:" and "then:" Spock blocks.
*/

class BasketWeightSpec extends spock.lang.Specification{

	def "A basket with one product has equal weight"() {
		given: "an empty basket and a TV"
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Basket basket = new Basket()

		when: "user wants to buy the TV"
		basket.addProduct(tv)

		then: "basket weight is equal to the TV"
		basket.currentWeight == tv.weight
	}

	def "A basket with two products weights as their sum"() {
		given: "an empty basket, a TV and a camera"
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		Basket basket = new Basket()

		when: "user wants to buy the TV and the camera"
		basket.addProduct(tv)
		basket.addProduct(camera)

		then: "basket weight is equal to both camera and tv"
		// Note: Spock will helpfully report the following incorrect use of "=" vs "==":
		//
		// You will see a warning like this:
		// mvn test
		// ...
		// [ERROR] .../BasketWeightSpec.groovy: 35: Expected a condition, but found an assignment. Did you intend to write '==' ? @ line 35, column 3.
		// [ERROR]    		basket.currentWeight = (tv.weight + camera.weight)
		basket.currentWeight == (tv.weight + camera.weight)
		//basket.currentWeight = (tv.weight + camera.weight)
	}
}
