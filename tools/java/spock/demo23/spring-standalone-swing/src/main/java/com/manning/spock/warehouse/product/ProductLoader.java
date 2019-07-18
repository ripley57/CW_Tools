package com.manning.spock.warehouse.product;

import java.util.List;

import javax.persistence.EntityManager;
import javax.persistence.PersistenceContext;

import org.springframework.stereotype.Repository;
import org.springframework.transaction.annotation.Propagation;
import org.springframework.transaction.annotation.Transactional;

/*
* JeremyC 18-07-2019
*
* The "@Repository"" annotation indicates that the class provides the mechanism
* for storage, retrieval, search, update and delete operation on objects.
* See https://www.journaldev.com/21460/spring-repository-annotation
*
* Notice the "em" object here and "setEm()" setter. I think it's fair to assume
* that the "@PersistenceContext" annotation above the "em" object name is linked 
* to the "setEm()" setter and Spring know that it needs to call this setter.
*/

@Repository
public class ProductLoader {
	@PersistenceContext
	private EntityManager em;
	
	@Transactional(propagation = Propagation.REQUIRED)
	public Product createDefaultProduct() {
		Product product = new Product();
		product.setName("A product");
		product.setPrice(0);
		product.setStock(0);
		product.setWeight(0);
		
		em.persist(product);
		return product;
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	public void save(Product product) {
		sanitizeProduct(product);
		em.persist(product);
		em.flush();
	}
	
	public List<Product> getAllProducts()
	{
		List<Product> result = (List<Product>) em
				.createQuery(
						"select product from Product product order by product.name")
				.getResultList();
		return result;
	}
	
	public Product findById(Long productID)
	{
		return em.find(Product.class, productID);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	public Product update(Product product)
	{
		sanitizeProduct(product);
		return em.merge(product);
	}
	
	@Transactional(propagation = Propagation.REQUIRED)
	public void delete(Long productID)
	{
		Product product = findById(productID);
	    if (product != null) {
	      em.remove(product);
	    }
	}
	
	private void sanitizeProduct(Product product)
	{
		product.setStock(Math.max(0,product.getStock()));
		product.setPrice(Math.max(0,product.getPrice()));
		product.setWeight(Math.max(0,product.getWeight()));
	}

	public void setEm(EntityManager em) {
		this.em = em;
	}
	
	
}
