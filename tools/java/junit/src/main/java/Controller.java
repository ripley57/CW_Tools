/**
 * This interface represents a controller. 
 *
 * A <CODE>Controller</CODE> handles a <CODE>Request</CODE>, by
 * invoking a <CODE>RequestHandler</CODE>, which in turn returns
 * a <CODE>Response</CODE>.
 *
 * @author JeremyC
 * @version 1.0
 */

public interface Controller 
{
	/**
	 *	Process a request.
	 *	@param request			The request to process
	 * 	@return					A <CODE>Response</CODE>
	 */
	Response processRequest(Request request);
	
	/**
	 *	Add a request handler.
	 *	@param request			The request to handle
	 *	@param requestHandler	The handler to handle the request
	 */
	void addHandler(Request request, RequestHandler requestHandler);
}