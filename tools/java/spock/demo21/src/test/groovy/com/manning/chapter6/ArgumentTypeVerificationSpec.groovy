package com.manning.chapter6

import spock.lang.*

import com.manning.chapter6.Basket
import com.manning.chapter6.Product
import com.manning.chapter6.ShippingCalculator;
import com.manning.chapter6.WarehouseInventory

@Subject(Basket.class)
class ArgumentTypeVerificationSpec extends spock.lang.Specification{

	def "Warehouse is queried for each product - null "() {
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
		// Remember: Any method call that causes interactions that
		// we check later, should be made here in  the "when:" block.
		boolean readyToShip = basket.canShipCompletely()

		then: "order can be shipped"
		readyToShip
		// Verify that non-null was passed:
		2 * inventory.isProductAvailable(!null ,1) >> true
	}
	
	def "Warehouse is queried for each product - type "() {
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
		// Here we verify the types of the passed arguments:
		2 * inventory.isProductAvailable(_ as String ,_ as Integer) >> true
	}
}

