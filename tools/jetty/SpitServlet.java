import java.io.*;

import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

public class SpitServlet extends HttpServlet
{
    public SpitServlet(){}

    /*
    **  HTTP GET demo
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().println("session=" + request.getSession(true).getId() + "<br/>");
		response.getWriter().println("<br/>Details: <br/>" + getRequestDetails(request, response));
		response.getWriter().println("<br/>Body:    <br/>" + getRequestBody(request, response)); 
		response.getWriter().println("<br/>Headers: <br/>" + getHeaders(request, response));
    }

    /*
    **  HTTP POST demo
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
        response.setContentType("text/html");
        response.setStatus(HttpServletResponse.SC_OK);
        response.getWriter().println("session=" + request.getSession(true).getId() + "<br/>s");
		response.getWriter().println("<br/>Details: <br/>" + getRequestDetails(request, response));
		response.getWriter().println("<br/>Body:    <br/>" + getRequestBody(request, response)); 
		response.getWriter().println("<br/>Headers: <br/>" + getHeaders(request, response));
    }

    private String getRequestBody(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    	StringBuilder buffer = new StringBuilder();
    	BufferedReader reader = request.getReader();
    	String line;
    	while ((line = reader.readLine()) != null) {
        	buffer.append(line);
			buffer.append("<br/>");
    	}
    	String data = buffer.toString();
		return data;
    }

    private String getRequestDetails(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
		String authType 	= "AuthType: "		+ request.getAuthType()	 	+ "<br/>";
		String contextPath	= "ContextPath: "	+ request.getContextPath()	+ "<br/>";
		String method		= "Methdd: " 		+ request.getMethod() 		+ "<br/>";
		String pathInfo		= "PathInfo: "		+ request.getPathInfo()		+ "<br/>";
		String queryString	= "QueryString: " 	+ request.getQueryString()	+ "<br/>";
		String remoteUser	= "RemoteUser: " 	+ request.getRemoteUser()	+ "<br/>";
		String requestURI	= "RequestURI: "	+ request.getRequestURI()	+ "<br/>";
		String sessionURL	= "SessionURL: "	+ request.getRequestURL()	+ "<br/>";
		String servletPath	= "ServletPath: " 	+ request.getServletPath()	+ "<br/>";
		return authType + contextPath + method + pathInfo + queryString + remoteUser + requestURI + sessionURL + servletPath;
    }
	
	private String getHeaders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		StringBuilder buffer = new StringBuilder();
		Enumeration headerNames = request.getHeaderNames();
		while (headerNames.hasMoreElements()) {
			String headerName = (String)headerNames.nextElement();
			buffer.append(headerName + ": " + request.getHeader(headerName) + "<br/>");
		}
		String data = buffer.toString();
		return data;
	}
}
