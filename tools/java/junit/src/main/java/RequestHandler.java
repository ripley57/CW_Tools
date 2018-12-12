/**
 * This interface represents a request handler. 
 *
 * The request handler accepts a <CODE>Request</CODE> and invokes
 * an appropriate handler to return a <CODE>Response</CODE>.
 *
 * @author JeremyC
 * @version 1.0
 */
public interface RequestHandler
{
	/**
	* Process the passed <CODE>Request</CODE>
	* @param request	The request to handle
	* @return 			A <CODE>Response</CODE>
	* @exception 		java.lang.Exception if there was an unexepected error.
	*/
	Response process(Request request) throws Exception;
}