package com.manning.chapter4.structure;

import java.util.HashMap;
import java.util.Map;
import java.util.Map.Entry;

import com.manning.chapter4.Product;

public class ProblematicBasket {

	protected Map<Product,Integer> contents = new HashMap<>();
	
	public void clearAllProducts()
	{
		contents.clear();
	}
	
	public void addProduct(Product product)
	{
		addProduct(product,1);
	}
	
	public void addProduct(Product product, int times)
	{
		// Intentional bug!!! 
		// Always only add one product regardless of "times" value.
		if(contents.containsKey(product))
		{
			int existing = contents.get(product);
			contents.put(product,existing);
		}
		else
		{
			contents.put(product,1);
		}
	}
	
	public int getCurrentWeight()
	{
		int total = 0;
		for(Entry<Product,Integer> entry:contents.entrySet())
		{
			total = total + (entry.getKey().getWeight() * entry.getValue());
		}
		
		return total;
	}
	
	public int getProductTypesCount()
	{
		return contents.size();
	}
	
/*
	// Uncomment this toString() override to see the benefits! See the README.md file.

	@Override
	public String toString()
	{
		StringBuilder builder = new StringBuilder("[ ");
		for (Entry<Product, Integer> entry:contents.entrySet())
		{
			builder.append(entry.getValue());
			builder.append(" x ");
			builder.append(entry.getKey().getName());
			builder.append(", ");
		}
		builder.setLength(builder.length()-2);
		
		return builder.append(" ]").toString();
	}
*/
}
