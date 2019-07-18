package com.manning.spock;

import org.springframework.web.client.RestTemplate

import spock.lang.*

/**
 * Rest tests using Spring Rest template
 *
 * The "@Stepwise" annotation indicates that the test methods here should be
 * run in the order that they are declared in this source file. In addition,
 * if any test method fails, those that come after it will be skipped.
 *
 * NOTE: In a real project, with hundreds of functional tests that may take
 *       minutes (or hours), the "@Stepwise" annotation is a huge teime-saver,lifesaver, 
 *       as it can drastically cut the time of developer feedback after a failed build.
 */
@Stepwise
class SpringRestSpec extends Specification {

	def "Simple status checker"() {
		when: "a rest call is performed to the status page"
		RestTemplate restTemplate = new RestTemplate()
		String status = restTemplate.getForObject("http://localhost:8080/rest-service-example/status", String.class)
		
		then: "the correct message is expected"
		status == "Up and Running"
	}
	
	def "Cleaning all products"() {
		given: "a rest call is performed that deletes everything"
		RestTemplate restTemplate = new RestTemplate()
		restTemplate.delete("http://localhost:8080/rest-service-example/products")
		
		when: "a product list is requested"
		List<Product> products = restTemplate.getForObject("http://localhost:8080/rest-service-example/products", List.class)
		
		then: "it should be empty"
		products.size() == 0
	}
	
	def "Creating a product"() {
		given: "a rest template"
		RestTemplate restTemplate = new RestTemplate()
		
		when: "a new product is created"
		Product product = restTemplate.postForObject("http://localhost:8080/rest-service-example/products","unused",Product.class)
		
		and: "product list is requested again"
		List<Product> products = restTemplate.getForObject("http://localhost:8080/rest-service-example/products", List.class)
		
		then: "it should have default values"
		with(product) {
			name == "A product"
			stock == 0
			price == 0
			weight == 0
		}
		
		and: "product list should contain it"
		products.size() == 1
	}
}
