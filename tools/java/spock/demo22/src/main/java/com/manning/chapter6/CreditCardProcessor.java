package com.manning.chapter6;

public interface CreditCardProcessor {

	CreditCardResult sale(int amount, Customer customer);
	
	CreditCardResult authorize(int amount, Customer customer);
	
	CreditCardResult capture(String token, Customer customer);
	
	void shutdown();
}
