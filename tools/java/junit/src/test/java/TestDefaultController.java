/**
 * Test the <CODE>DefaultController</CODE> class
 */

import org.junit.*;

/*
** Static import is a feature introduced in the Java programming language that allows 
** members defined in a class as public static to be used in Java code without specifying 
** the class in which the field is defined. This feature was introduced into the language 
** in version 5.0.
*/
import static org.junit.Assert.*;

public class TestDefaultController
{
	private DefaultController controller;
	private Request request;
	private RequestHandler handler;
 
	@Before
	public void instantiate() throws Exception
	{
		controller = new DefaultController();
		request = new SampleRequest();
		handler = new SampleHandler();
		controller.addHandler(request, handler); 
	}

	@Test
	public void testAddHandler() 
	{
		RequestHandler handler2 = controller.getHandler(request); 
		assertSame("Handler we set in controller should be the same handler we get", handler2, handler);
	}
	
	@Test
	public void testProcessRequest()
	{
		Response response = controller.processRequest(request);
		assertNotNull("Must not return a null response", response);
		assertEquals("Response should be of type SampleResponse", SampleResponse.class, response.getClass());
		assertEquals(new SampleResponse(), response);		
	}
	
	@Test
	public void testProcessRequestAnswersErrorResponse()
	{
		SampleRequest request = new SampleRequest("testError");
		SampleExceptionHandler handler = new SampleExceptionHandler();
		controller.addHandler(request, handler);
		Response response = controller.processRequest(request);
		assertNotNull("Must not return a null response", response);
		assertEquals(ErrorResponse.class, response.getClass());
	}
	
	@Test(expected=RuntimeException.class)
	public void testGetHandlerNotDefined()
	{
		SampleRequest request = new SampleRequest("testNotDefined");
		//The following line is supposed to throw a RuntimeException
		controller.getHandler(request);
	}
	
	@Test(expected=RuntimeException.class)
	public void testAddRequestDuplicateName()
	{
		SampleRequest request = new SampleRequest();
		SampleHandler handler = new SampleHandler();
		// The following line is supposed to throw a RuntimeException
		controller.addHandler(request, handler);
	}
	
	/*
	** NOTE: 
	**
	** This is an example of a "non-deterministic test". This is because
	** the test is time-based, so it might work on someones system, but
	** fail on someone else's. 
	** See https://martinfowler.com/articles/nonDeterminism.html
	**
	** Junit v4 allows us to skip certain tests, by using the "@Ignore" annotation.
 	*/
	@Test(timeout=130)
	@Ignore(value="Ignore for now until we decide a decent time-limit")
	public void testProcessMultipleRequestsTimeout()
	{
		Request request;
		Response response = new SampleResponse();
		RequestHandler handler = new SampleHandler();
		for(int i=0; i< 99999; i++)
		{
			request = new SampleRequest(String.valueOf(i));
			controller.addHandler(request, handler);
			response = controller.processRequest(request);
			assertNotNull(response);
			assertNotSame(ErrorResponse.class, response.getClass());
		}
	}
	
	/*
	** Test classes.
	**
	** Note: Because our test classes are simple, we will define them here as inner classes. 
	*/
	
	private class SampleRequest implements Request
	{
		private static final String DEFAULT_NAME = "Test"; 
		private final String name;
		
		public SampleRequest(String name)
		{
			this.name = name;
		}
		
		public SampleRequest()
		{
			this(DEFAULT_NAME);
		}	 
		
		public String getName()
		{
			return this.name;
		}
	}
	
	private class SampleResponse implements Response
	{
		private static final String NAME = "Test";
		public String getName()
		{
			return NAME;
		}
		public boolean equals(Object object)
		{
			if (object instanceof SampleResponse) {
				return ((SampleResponse)object).getName().equals(getName());
			}
			return false;
		}
	}
	
	private class SampleHandler implements RequestHandler
	{
		public Response process(Request request) throws Exception
		{
			return new SampleResponse();
		}
	}
	
	private class SampleExceptionHandler implements RequestHandler
	{
		public Response process(Request request) throws Exception
		{
			throw new Exception("error processing request");
		}
	}

}
