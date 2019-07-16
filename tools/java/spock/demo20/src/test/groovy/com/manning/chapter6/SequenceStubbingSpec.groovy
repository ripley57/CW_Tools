package com.manning.chapter6

import spock.lang.*

import com.manning.chapter6.Basket
import com.manning.chapter6.Product

@Subject(Basket.class)
class SequenceStubbingSpec extends spock.lang.Specification{

	def "Inventory is always checked in the last possible moment"() {
		given: "a basket and a TV"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)

		and:"a warehouse with fluctuating stock levels"
		WarehouseInventory inventory = Stub(WarehouseInventory)
		// Note: Stub different reposonses depending on number of calls.
		// An alternate syntax is to use a Collection/Iterator here,
 		// instead of a list of respoonses. 
		inventory.isProductAvailable( "bravia", _) >>> true >> false
		inventory.isEmpty() >>> [false, true]
		basket.setWarehouseInventory(inventory)

		when: "user checks out the tv"
		basket.addProduct tv

		then: "order can be shipped right away"
		basket.canShipCompletely()
		
		when: "user wants another TV"
		basket.addProduct tv

		then: "order can no longer be shipped"
		!basket.canShipCompletely()
	}
}
