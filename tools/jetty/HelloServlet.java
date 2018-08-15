import java.io.*;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class HelloServlet extends HttpServlet
{
    private String greeting="Hello World";

    public HelloServlet(){}

    public HelloServlet(String greeting)
    {
        this.greeting=greeting;
    }

    /*
    **  HTTP GET demo
    **
    **  To test this out, use web browser and go to http://localhost:8080/ctx0/it/
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().println("<h1>doGet: "+greeting+"</h1>");
        response.getWriter().println("session=" + request.getSession(true).getId());

	System.out.println("\nGET request: ");
	System.out.println("Details: \n" + getRequestDetails(request, response));
	System.out.println("Body: \n" + getRequestBody(request, response)); 
	//response.getWriter().println("request:" + data);
    }

    /*
    **  HTTP POST demo
    **
    ** 	To test this out, use a telnet client (or nc command) to send something like this:
    **	POST /ctx0/it/ HTTP/1.0
    **	From: frog@jmarshall.com
    **	User-Agent: HTTPTool/1.0
    **	Content-Type: application/x-www-form-urlencoded
    **	Content-Length: 32
    **
    **	home=Cosby&favorite+flavor=flies
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().println("<h1>doPost: "+greeting+"</h1>");
        response.getWriter().println("session=" + request.getSession(true).getId());

	System.out.println("\nPOST request: ");
	System.out.println("Details: \n" + getRequestDetails(request, response));
	System.out.println("Body: \n" + getRequestBody(request, response)); 
	//response.getWriter().println("request:" + data);
    }

    private String getRequestBody(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    	StringBuilder buffer = new StringBuilder();
    	BufferedReader reader = request.getReader();
    	String line;
    	while ((line = reader.readLine()) != null) {
        	buffer.append(line);
    	}
    	String data = buffer.toString();
	return data;
    }

    private String getRequestDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
	String authType 	= "AuthType: "		+ request.getAuthType()	 	+ "\n";
	String contextPath	= "ContextPath: "	+ request.getContextPath()	+ "\n";
	String method		= "Methdd: " 		+ request.getMethod() 		+ "\n";
	String pathInfo		= "PathInfo: "		+ request.getPathInfo()		+ "\n";
	String queryString	= "QueryString: " 	+ request.getQueryString()	+ "\n";
	String remoteUser	= "RemoteUser: " 	+ request.getRemoteUser()	+ "\n";
	String requestURI	= "RequestURI: "	+ request.getRequestURI()	+ "\n";
	String sessionURL	= "SessionURL: "	+ request.getRequestURL()	+ "\n";
	String servletPath	= "ServletPath: " 	+ request.getServletPath()	+ "\n";
	
	return authType + contextPath + method + pathInfo + queryString + remoteUser + requestURI + sessionURL + servletPath;
    }
}
