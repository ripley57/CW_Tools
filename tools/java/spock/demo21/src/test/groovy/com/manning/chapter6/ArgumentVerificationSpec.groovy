package com.manning.chapter6

import spock.lang.*

import com.manning.chapter6.Basket
import com.manning.chapter6.Product
import com.manning.chapter6.WarehouseInventory

@Subject(BillableBasket.class)
class ArgumentVerificationSpec extends spock.lang.Specification{

	//@Ignore
	def "vip status is correctly passed to credit card - simple"() {
		given: "a basket, a customer, a tv, and a camera"
		BillableBasket basket = new BillableBasket()
		Customer customer = new Customer(name:"John",vip:false,creditCard:"testCard")
		// ME: Let's create some additional customer objects, to see if using these
		//     instead of "customer" cause the test to fail.
		Customer customer2 = new Customer(name:"XXX",vip:false,creditCard:"testCard")
		Customer customer3 = new Customer(name:"John",vip:false,creditCard:"testCard")
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)

		and: "a credit card service"
		CreditCardProcessor creditCardSevice = Mock(CreditCardProcessor)
		basket.setCreditCardProcessor(creditCardSevice)

		when: "user checks out two products"
		basket.addProduct tv
		basket.addProduct camera
		basket.checkout(customer)	;// Note: This is the only customer object we are using in the mock.

		then: "credit card is charged"
		// This passes:
		1 * creditCardSevice.sale(1550, customer)
		// NOTE:  This causes a fail. Even though the contents of the "customer3"
		// object are the same as the "customer" object, the check below expects the
		// "customer" object to have been used:
		//1 * creditCardSevice.sale(1550, customer3)
	}
	
	//@Ignore
	def "vip status is correctly passed to credit card - vip"() {
		given: "a basket, a customer, a tv, and a camera"
		BillableBasket basket = new BillableBasket()
		Customer customer = new Customer(name:"John",vip:false,creditCard:"testCard")
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)

		and: "a credit card service"
		CreditCardProcessor creditCardSevice = Mock(CreditCardProcessor)
		basket.setCreditCardProcessor(creditCardSevice)

		when: "user checks out two products"
		basket.addProduct tv
		basket.addProduct camera
		basket.checkout(customer)

		then: "credit card is charged"
		// Here, the 2nd argument passed (a Customer object) must have a "vip" field value of "false":
		1 * creditCardSevice.sale(1550, { client -> client.vip == false})
	}
	
	//@Ignore
	def "vip status is correctly passed to credit card - full"() {
		given: "a basket, a customer, a tv, and a camera"
		BillableBasket basket = new BillableBasket()
		Customer customer = new Customer(name:"John",vip:false,creditCard:"testCard")
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)

		and: "a credit card service"
		CreditCardProcessor creditCardSevice = Mock(CreditCardProcessor)
		basket.setCreditCardProcessor(creditCardSevice)

		when: "user checks out two products"
		basket.addProduct tv
		basket.addProduct camera
		basket.checkout(customer)

		then: "credit card is charged"
		// Here we use a closure for both input arguments:
		1 * creditCardSevice.sale({amount -> amount == basket.findOrderPrice()}, { client -> client.vip == false})
	}
}
