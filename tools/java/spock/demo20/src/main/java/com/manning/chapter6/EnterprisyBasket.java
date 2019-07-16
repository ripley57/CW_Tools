package com.manning.chapter6;

import com.manning.chapter6.Basket;

public class EnterprisyBasket extends Basket{

	public EnterprisyBasket(ServiceLocator serviceLocator)
	{
		setWarehouseInventory(serviceLocator.getWarehouseInventory());
	}
}
