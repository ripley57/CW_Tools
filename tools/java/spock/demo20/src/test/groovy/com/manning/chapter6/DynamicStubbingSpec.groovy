package com.manning.chapter6

import spock.lang.*

import com.manning.chapter6.Basket
import com.manning.chapter6.Product

@Subject(Basket.class)
class DynamicStubbingSpec extends spock.lang.Specification{

	def "Basket handles shipping charges according to product count - static"() {
		given: "a basket and several products"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		Product hifi = new Product(name:"jvc",price:600,weight:5)
		Product laptop = new Product(name:"toshiba",price:800,weight:10)

		and: "a fully stocked warehouse"
		WarehouseInventory inventory = Stub(WarehouseInventory)
		inventory.isProductAvailable( _ , _) >> true
		basket.setWarehouseInventory(inventory)

		and: "a shipping calculator that charges 10 dollars for each product"
		ShippingCalculator shippingCalculator = Stub(ShippingCalculator)
		// Here we use a messy way to calculate stub value to return:
		shippingCalculator.findShippingCostFor(tv, 2) >> 20
		shippingCalculator.findShippingCostFor( camera, 2) >> 20
		shippingCalculator.findShippingCostFor(hifi, 1) >> 10
		shippingCalculator.findShippingCostFor(laptop, 3) >> 30
		basket.setShippingCalculator(shippingCalculator)

		when: "user checks out several products in different quantities"
		basket.addProduct tv, 2
		basket.addProduct camera, 2
		basket.addProduct hifi
		basket.addProduct laptop, 3

		then: "cost is correctly calculated"
		basket.findTotalCost() == 2 * tv.price + 2 * camera.price + 1 * hifi.price + 3 * laptop.price + basket.getProductCount() * 10
	}
	
	def "Basket handles shipping charges according to product count"() {
		given: "a basket and several products"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		Product hifi = new Product(name:"jvc",price:600,weight:5)
		Product laptop = new Product(name:"toshiba",price:800,weight:10)

		and: "a fully stocked warehouse"
		WarehouseInventory inventory = Stub(WarehouseInventory)
		inventory.isProductAvailable( _ , _) >> true
		basket.setWarehouseInventory(inventory)

		and: "a shipping calculator that charges 10 dollars for each product"
		ShippingCalculator shippingCalculator = Stub(ShippingCalculator)
		// Here we use a much simpler way (using a closure) to do the same thing!:
		shippingCalculator.findShippingCostFor( _, _) >> { Product product, int count ->  10 * count}
		basket.setShippingCalculator(shippingCalculator)

		when: "user checks out several products in different quantities"
		basket.addProduct tv, 2
		basket.addProduct camera, 2
		basket.addProduct hifi
		basket.addProduct laptop, 3

		then: "cost is correctly calculated"
		basket.findTotalCost() == 2 * tv.price + 2 * camera.price + 1 * hifi.price + 3 * laptop.price + basket.getProductCount() * 10
	}
	
	def "Downloadable goods do not have shipping cost - static"() {
		given: "a basket and several products"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		Product hifi = new Product(name:"jvc",price:600,weight:5)
		Product laptop = new Product(name:"toshiba",price:800,weight:10)
		Product ebook = new Product(name:"learning exposure",price:30,weight:0)
		Product suite = new Product(name:"adobe essentials",price:200,weight:0)

		and: "a fully stocked warehouse"
		WarehouseInventory inventory = Stub(WarehouseInventory)
		inventory.isProductAvailable( _ , _) >> true
		basket.setWarehouseInventory(inventory)

		and: "a shipping calculator that charges 10 dollars for each physical product"
		ShippingCalculator shippingCalculator = Stub(ShippingCalculator)
		// Note: We have introduced some products that can be downloaded, so for
		//	 these we need to make the shipping cost 0. Here's how we might do
		//	 this, but notice that we have to explicitly add each product again,
		//	 so that we can use ">> 0" for the downloadable products.
		//	 (See the next test for a better approach!)
		shippingCalculator.findShippingCostFor(tv,2) >> 20
		shippingCalculator.findShippingCostFor(camera,2) >> 20
		shippingCalculator.findShippingCostFor(hifi,1) >> 10
		shippingCalculator.findShippingCostFor(laptop, 1) >> 10
		shippingCalculator.findShippingCostFor( ebook,1) >> 0
		shippingCalculator.findShippingCostFor(suite, 3 ) >> 0
		basket.setShippingCalculator(shippingCalculator)

		when: "user checks out several products in different quantities"
		basket.addProduct tv,2
		basket.addProduct camera,2
		basket.addProduct hifi
		basket.addProduct laptop
		basket.addProduct ebook
		basket.addProduct suite,3

		then: "cost is correctly calculated"
		basket.findTotalCost() == 2 * tv.price + 2 * camera.price + 1 * hifi.price + 1 * laptop.price + 1 * ebook.price + 3 * suite.price + 60
	}

	def "Downloadable goods do not have shipping cost"() {
		given: "a basket and several products"
		Basket basket = new Basket()
		Product tv = new Product(name:"bravia",price:1200,weight:18)
		Product camera = new Product(name:"panasonic",price:350,weight:2)
		Product hifi = new Product(name:"jvc",price:600,weight:5)
		Product laptop = new Product(name:"toshiba",price:800,weight:10)
		Product ebook = new Product(name:"learning exposure",price:30,weight:0)
		Product suite = new Product(name:"adobe essentials",price:200,weight:0)

		and: "a fully stocked warehouse"
		WarehouseInventory inventory = Stub(WarehouseInventory)
		inventory.isProductAvailable( _ , _) >> true
		basket.setWarehouseInventory(inventory)

		and: "a shipping calculator that charges 10 dollars for each physical product"
		ShippingCalculator shippingCalculator = Stub(ShippingCalculator)
		// Note: Here's the improved approach vs the previous test method above:
		shippingCalculator.findShippingCostFor( _, _) >> { Product product, int count ->  product.weight==0 ? 0 : 10 * count}
		basket.setShippingCalculator(shippingCalculator)

		when: "user checks out several products in different quantities"
		basket.addProduct tv,2
		basket.addProduct camera,2
		basket.addProduct hifi
		basket.addProduct laptop
		basket.addProduct ebook
		basket.addProduct suite,3

		then: "cost is correctly calculated"
		basket.findTotalCost() == 2 * tv.price + 2 * camera.price + 1 * hifi.price + 1 * laptop.price  + 1 * ebook.price + 3 * suite.price + 60
	}
}
