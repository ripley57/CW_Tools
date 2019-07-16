package com.manning.chapter6

import spock.lang.*

import com.manning.chapter6.Basket
import com.manning.chapter6.Product

@Subject(Basket.class)
class ExceptionStubbingSpec extends spock.lang.Specification{

	def "A problematic inventory means nothing can be shipped"() {
		given: "a basket and a TV"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)

		and:"a warehouse with serious issues"
		WarehouseInventory inventory = Stub(WarehouseInventory)
		inventory.isProductAvailable( "bravia", _) >> { throw new RuntimeException("critical error") }
		basket.setWarehouseInventory(inventory)

		when: "user checks out the tv"
		basket.addProduct tv

		then: "order cannot be shipped"
		!basket.canShipCompletely()
	}
}
