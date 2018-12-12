/**
 * NOTE: This JUnit demo is based on pages up to page 53 of JUnit In Action.
 *
 * This class implements the <I>Controller</I> pattern.
 *
 * <P>
 * In general, a controller does the following:
 * o Accepts requests
 * o Performs any common computations on the request
 * o Selects an appropriate request handler
 * o Routes the request so that the handler can execute the relevant business logic
 * o May provide a top-level handler for errors and exceptions
 * </P>
 *
 * @author JeremyC
 * @version 1.0
 */
 
import java.util.HashMap;
import java.util.Map;

public class DefaultController implements Controller
{
	private Map<String,RequestHandler> requestHandlers = new HashMap<String,RequestHandler>();
	
	protected RequestHandler getHandler(Request request)
	{
		if (!this.requestHandlers.containsKey(request.getName()))
		{
			String message = "Cannot find handler for request name " + "[" + request.getName() + "]";
			throw new RuntimeException(message);
		}
		return this.requestHandlers.get(request.getName());
	}
	
	/**
	 * Process a <CODE>Request</CODE>
	 * @param request	The request to process.
	 * @return			A <CODE>Response</CODE>. Note that we handle any exception and return it as a <CODE>Response</CODE>.
	 */
	public Response processRequest(Request request)
	{
		Response response;
		try
		{
			response = getHandler(request).process(request);
		}
		catch (Exception exception)
		{
			response = new ErrorResponse(request, exception);
		}
		return response;
	}
	
	/**
	* Register a handler for a specific <CODE>Request</CODE>
	* <P>
	* Registering a handler with the controller is an example of Inversion of Control. You
	* may know this pattern as the Hollywood Principle, or “Don’t call us, we’ll call you.”
	* Objects register as handlers for an event. When the event occurs, a hook method
	* on the registered object is invoked. Inversion of Control lets frameworks manage
	* the event lifecycle while allowing developers to plug in custom handlers for framework events.
	* </P>
	*
	* @param request			The <CODE>Request</CODE> to handle
	* @param requestHandler		The <CODE>RequestHandler</CODE> to handle this <CODE>Request</CODE>
	*/
	public void addHandler(Request request, RequestHandler requestHandler)
	{
		if (this.requestHandlers.containsKey(request.getName()))
		{
			String s = "A request handler has " + "already been registered for request name " + "[" + request.getName() + "]";
			throw new RuntimeException(s);
		}
		else
		{
			this.requestHandlers.put(request.getName(), requestHandler);
		}
	}
}
 
