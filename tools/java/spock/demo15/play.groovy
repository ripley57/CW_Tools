
/*
** Comment/uncomment the various uses of "with()" struct, to confirm
** the constructs that are pure Groovy and those that require Spock.
*/

class Product {
	String name
	int price
	int weight
}

Product laptop = new Product(name:"toshiba",price:1200,weight:5)
Product camera = new Product(name:"panasonic",price:350,weight:2)
Product hifi = new Product(name:"jvc",price:600,weight:5)

class WarehouseInventory {
	def preload( product , count ) {
	}

	def getBoxesMovedToday() {
		return 5
	}
}

WarehouseInventory warehouseInventory = new WarehouseInventory()

warehouseInventory.with {
	preload laptop,3
	preload camera,5
	preload hifi,2
}

warehouseInventory.with {
	getBoxesMovedToday() == 5
}

/*
	// NOTE: This is Spock syntax. This is therefore not pure Groovy, so the "groovy" command-line doesn't like it!
with(warehouseInventory) {
	getBoxesMovedToday() == 5
}
*/
