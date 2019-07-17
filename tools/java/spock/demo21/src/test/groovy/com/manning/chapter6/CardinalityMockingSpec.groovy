package com.manning.chapter6

import spock.lang.*

import com.manning.chapter6.Basket
import com.manning.chapter6.Product
import com.manning.chapter6.ShippingCalculator;
import com.manning.chapter6.WarehouseInventory

@Subject(Basket.class)
class CardinalityMockingSpec extends spock.lang.Specification{

	def "Warehouse is queried for each product"() {
		given: "a basket, a TV and a camera"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		
		and: "a warehouse with limitless stock"
		WarehouseInventory inventory = Mock(WarehouseInventory)
		basket.setWarehouseInventory(inventory)

		when: "user checks out both products"
		basket.addProduct tv
		basket.addProduct camera
		// NOTE: method interactions should be done inside the "when:" block.
		// Spock records the interactions of mocks in the "when:" block.
		// This means that, if we call a method that generates interactions
		// that we want to check later in the "then:" block, then we must make
		// that method call in the "when:" block and not in the "then:" block.
		// Therefore, if you were to move the following line into the "then:"
		// block, the interaction method count check would fail!
		boolean readyToShip = basket.canShipCompletely()

		then: "order can be shipped"
		readyToShip
		2 * inventory.isProductAvailable( _ , _) >> true
		0 * inventory.preload(_ , _)
	}
	
	def "Warehouse is queried for each product - strict"() {
		given: "a basket, a TV and a camera"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		
		and: "a warehouse with limitless stock"
		WarehouseInventory inventory = Mock(WarehouseInventory)
		basket.setWarehouseInventory(inventory)

		when: "user checks out both products"
		basket.addProduct tv
		basket.addProduct camera
		boolean readyToShip = basket.canShipCompletely()

		then: "order can be shipped"
		readyToShip
		2 * inventory.isProductAvailable( _ , _) >> true
		1 * inventory.isEmpty() >> false
		// NOTE: Here we impose a strict verification, i.e. that only the
		//	 "isProductAvailable()" and "isEmpty()" methods were called.
		0 * inventory._
	}
	
	def "Only warehouse is queried when checking shipping status"() {
		given: "a basket, a TV and a camera"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		
		and: "a warehouse with limitless stock"
		WarehouseInventory inventory = Mock(WarehouseInventory)
		basket.setWarehouseInventory(inventory)
		ShippingCalculator shippingCalculator = Mock(ShippingCalculator)
		basket.setShippingCalculator(shippingCalculator)

		when: "user checks out both products"
		basket.addProduct tv
		basket.addProduct camera
		boolean readyToShip = basket.canShipCompletely()

		then: "order can be shipped"
		readyToShip
		// We expect "isProductAvailable()" to be called twice, and we use
		// Spock "argument matchers" to indicate we don't care what the 
		// arguments were:
		2 * inventory.isProductAvailable( _ , _) >> true
		// We don't care how many times "isEmpty()" is called, and we also stub
		// it to always return false:
		_ * inventory.isEmpty() >> false
		// No other methods should be called, including methods from any other 
		// mock in the test:
		0 * _
	}
}
