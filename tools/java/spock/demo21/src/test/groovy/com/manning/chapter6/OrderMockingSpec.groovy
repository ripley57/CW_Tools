package com.manning.chapter6

import spock.lang.*

import com.manning.chapter6.Basket
import com.manning.chapter6.Product
import com.manning.chapter6.WarehouseInventory

@Subject(BillableBasket.class)
class OrderMockingSpec extends spock.lang.Specification{

	def "credit card connection is closed down in the end - incorrect"() {
		given: "a basket, a customer and a TV"
		BillableBasket basket = new BillableBasket()
		Customer customer = new Customer(name:"John",vip:false,creditCard:"testCard")
		Product tv = new Product(name:"bravia",price:1200,weight:18)

		and: "a credit card service"
		CreditCardProcessor creditCardSevice = Mock(CreditCardProcessor)
		basket.setCreditCardProcessor(creditCardSevice)

		when: "user checks out the tv"
		basket.addProduct tv
		basket.checkout(customer)

		// Order of invocations in then block does not matter to Spock
		// These two checks could happen in any order by Spock!
		// See the next test method for the solution!
		then: "credit card is charged and CC service is closed down"
		1 * creditCardSevice.shutdown()
		1 * creditCardSevice.sale(1200,customer)
	}


	def "credit card connection is closed down in the end"() {
		given: "a basket, a customer and a TV"
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		BillableBasket basket = new BillableBasket()
		Customer customer = new Customer(name:"John",vip:false,creditCard:"testCard")

		and: "a credit card service"
		CreditCardProcessor creditCardSevice = Mock(CreditCardProcessor)
		basket.setCreditCardProcessor(creditCardSevice)

		when: "user checks out the tv"
		basket.addProduct tv
		basket.checkout(customer)

		then: "credit card is charged and"
		// We're using Spock "arguments matchers" here too.
		1 * creditCardSevice.sale( _, _)

		then: "the credit card service is closed down"
		1 * creditCardSevice.shutdown()
	}
}
