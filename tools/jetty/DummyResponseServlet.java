import java.io.*;

import java.util.Enumeration;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.eclipse.jetty.util.log.Log;
import org.eclipse.jetty.util.log.Logger;

public class DummyResponseServlet extends HttpServlet
{
	private static final Logger LOG = Log.getLogger(MyServer.class);
	
    public DummyResponseServlet(){}
	
	private void logRequestAndReturnJSONSuccess(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		LOG.info("");
		LOG.info("Details: "	+ getRequestDetails(request, response));
		LOG.info("");
		LOG.info("Body: " 		+ getRequestBody(request, response));
		LOG.info("");
		LOG.info("Headers: " 	+ getHeaders(request, response));
		LOG.info("");
					
		/* We don't need this preamble - in fact, the ExtJS form doesn't like it.
		StringBuilder sb = new StringBuilder();
		sb.append("Content-Type: text/json;charset=UTF-8\n");
		sb.append("Content-Length: " + resp.length() + "\n");
		sb.append("\n");
		sb.append(resp);
		*/
		String resp = "{\"success\":true}";
		response.getWriter().println(resp.toString());
	}

    /*
    **  HTTP GET 
    */
    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
		logRequestAndReturnJSONSuccess(request, response);
    }

    /*
    **  HTTP POST 
    */
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
		logRequestAndReturnJSONSuccess(request, response);
    }

    private String getRequestBody(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
    {
    	StringBuilder buffer = new StringBuilder();
    	BufferedReader reader = request.getReader();
    	String line;
    	while ((line = reader.readLine()) != null) {
        	buffer.append(line);
			buffer.append("\n");
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
	
	private String getHeaders(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException
	{
		StringBuilder buffer = new StringBuilder();
		Enumeration headerNames = request.getHeaderNames();
		while (headerNames.hasMoreElements()) {
			String headerName = (String)headerNames.nextElement();
			buffer.append(headerName + ": " + request.getHeader(headerName) + "\n");
		}
		String data = buffer.toString();
		return data;
	}
}
