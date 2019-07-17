package com.manning.chapter6

import spock.lang.*

import com.manning.chapter6.Basket
import com.manning.chapter6.Product
import com.manning.chapter6.WarehouseInventory

class SimpleMockingSpec extends spock.lang.Specification{

	// Fortuntately, the Basket.java class has a "canShipComplete()" method 
	// that	we can call to verify it - so we should really be using a stub
	// stub here instead of a mock. This test is simply to demonstrate that a
	// mock can always be used in place of a stub in Spock, but not vice versa!
	// (remember, a mock is a superset of a stub).
	def "If the warehouse is empty nothing can be shipped"() {
		given: "a basket and a TV"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		
		and: "an empty warehouse"
		WarehouseInventory inventory = Mock(WarehouseInventory)
		inventory.isEmpty() >> true
		basket.setWarehouseInventory(inventory)

		when: "user checks out the tv"
		basket.addProduct tv

		then: "order cannot be shipped"
		!basket.canShipCompletely()
	}
	
	// Here we need to verify that the "shutdown()" method of the CreditCardProcessor
	// class was called. We don't have a "shutdownWasCalled()" method, so we need to
	// use a mock here instead of a stub.
	def "credit card connection is always closed down"() {
		given: "a basket, a customer and a TV"
		BillableBasket basket = new BillableBasket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Customer customer = new Customer(name:"John",vip:false,creditCard:"testCard")
		
		and: "a credit card service"
		CreditCardProcessor creditCardSevice = Mock(CreditCardProcessor)
		basket.setCreditCardProcessor(creditCardSevice)

		when: "user checks out the tv"
		basket.addProduct tv
		basket.checkout(customer)

		then: "connection is always closed at the end"
		1 * creditCardSevice.shutdown()
	}
}
