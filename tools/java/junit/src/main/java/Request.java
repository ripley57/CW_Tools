/**
 * This interface represents a request sent to a <CODE>RequestHandler</CODE> 
 *
 * @author JeremyC
 * @version 1.0
 */
public interface Request
{
    /**
	 * @return	The request's unique name (so we can differentiate one request from another). 
	 */
	String getName();
}