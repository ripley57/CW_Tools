package com.manning.chapter6;

import com.manning.chapter6.Product;

public interface ShippingCalculator {
	int findShippingCostFor(Product product, int times);
}
