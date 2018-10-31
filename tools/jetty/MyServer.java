/*
** Description:
**
**   This program does the following:
**
**     1. File server for the current directory.
**        Accessed via http://localhost:9090/list
**
**     2. Servlet that spits the request including HTTP headers such as User-Agent:
**        http://localhost:9090/ctx2/spit/
**
**     3. Execute CGI scripts.
**        Accessed via http://localhost:9090/ctx1/cgi-bin
**
**     4. Simple demo servlet.
**        Accessed via http://localhost:9090/ctx0/it
**
**	   5. Simple dummy response servlet.
**        Accessed via http://localhost:8080/ctx2/dummyresponse/
**
**   To enable DEBUG logging, make sure that file
**   jetty-logging.properties is on the classpath.
**
**   JeremyC 31/10/2018
*/
 
import org.apache.commons.codec.binary.Base64;
import java.io.IOException;
import javax.servlet.ServletContext;
import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import org.eclipse.jetty.server.Handler;
import org.eclipse.jetty.server.Server;
import org.eclipse.jetty.server.Request;
import org.eclipse.jetty.servlet.ServletHolder;
import org.eclipse.jetty.servlet.ServletContextHandler;
import org.eclipse.jetty.server.handler.ContextHandler;
import org.eclipse.jetty.server.handler.ContextHandlerCollection;
import org.eclipse.jetty.server.handler.DefaultHandler;
import org.eclipse.jetty.server.handler.HandlerList;
import org.eclipse.jetty.server.handler.ResourceHandler;
import org.eclipse.jetty.servlets.CGI;
import org.eclipse.jetty.servlets.MyCGI;
 
import org.eclipse.jetty.server.Connector;
import org.eclipse.jetty.util.log.Log;
import org.eclipse.jetty.util.log.Logger;

public class MyServer
{
	  private static final Logger LOG = Log.getLogger(MyServer.class);
		
      public static void main(String[] args) throws Exception
      {
        Server server = new Server(args.length == 0 ? 8080 : Integer.parseInt(args[0]));

		// Increase response header size, for GET requests that can often return large
		// JSON respones (e.g. the ExtInAction 2nd Ed sample programs in chapter 08). 
		Connector[] connectors = server.getConnectors();
		for (Connector connector : connectors) {
			LOG.info("**** MyServer connector: ");
			LOG.info("**** current reposonse header size: " + connector.getResponseHeaderSize());
			LOG.info("**** name: " + connector.getName());
			LOG.info("**** host: " + connector.getHost());
			connector.setResponseHeaderSize(100000);
			LOG.info("**** new response header size: " + connector.getResponseHeaderSize());
		}
				
        ResourceHandler resource_handler = new ResourceHandler() {

		// Override to provide basic user authentication.
		public void handle(String target, Request baseRequest, HttpServletRequest request, HttpServletResponse response)
			throws 	IOException, ServletException
		{
			String authHeader = request.getHeader("Authorization");
    			if (authHeader != null && authHeader.startsWith("Basic ")) {
        			String[] up = parseBasic(authHeader.substring(authHeader.indexOf(" ") + 1));
        			String username = up[0];
        			String password = up[1];
        			if (authenticateUser(username, password)) {
            				super.handle(target, baseRequest, request, response);
            				return;
        			}
    			}
    			response.setHeader("WWW-Authenticate", "BASIC realm=\"SecureFiles\"");
    			response.sendError(HttpServletResponse.SC_UNAUTHORIZED, "Please provide username and password");
		}

		private boolean authenticateUser(String username, String password) {
			// Perform user authentication.
			//System.out.println("username=" + username + ", password=" + password);
			if (username.equals("BL") && password.equals("BLBL")) 
				return true;	// authentication successful
			return false;
		}

		private String[] parseBasic(String enc) {
			byte[] bytes = Base64.decodeBase64(enc.getBytes());
			String s = new String(bytes);
			int pos = s.indexOf( ":" );
 			if( pos >= 0 )
				return new String[] { s.substring( 0, pos ), s.substring( pos + 1 ) };
			else
				return new String[] { s, null };
		}
	  };
		  
	resource_handler.setDirectoriesListed(true);
	resource_handler.setWelcomeFiles(new String[]{ "index.html" });
	resource_handler.setResourceBase(args.length == 2 ? args[1] : ".");
		
	ServletContextHandler context0 = new ServletContextHandler(ServletContextHandler.SESSIONS);
	context0.setResourceBase(args.length == 2 ? args[1] : ".");
	context0.setContextPath("/ctx0");

	ServletContextHandler context1 = new ServletContextHandler(ServletContextHandler.SESSIONS);
	context1.setResourceBase(args.length == 2 ? args[1] : ".");
	context1.setContextPath("/ctx1");
		  
	ServletContextHandler context2 = new ServletContextHandler(ServletContextHandler.SESSIONS);
	context2.setResourceBase(args.length == 2 ? args[1] : ".");
	context2.setContextPath("/ctx2");
		
	ContextHandler context3 = new ContextHandler("/list");
	context3.setHandler(resource_handler);

	ContextHandlerCollection contexts = new ContextHandlerCollection();
	contexts.setHandlers(new Handler[] { context3, context2, context0, context1 });
	server.setHandler(contexts);

	ServletHolder holder_ctx0 = new ServletHolder(new HelloServlet("Buongiorno Mondo"));
	context0.addServlet(holder_ctx0, "/it/*");

        ServletHolder holder_cgi = new ServletHolder(new CGI());
	holder_cgi.setInitParameter("cgibinResourceBase", "cgi-bin");
	holder_cgi.setInitParameter("cgibinResourceBaseIsRelative","true");
        context1.addServlet(holder_cgi,"/cgi-bin/*");
		
	// My own MyCGI class which strips-off the query-string from a GET request.
	// To invoke this: http://localhost:8080/ctx1/cgi-bin2/demo.bat
       	ServletHolder holder_cgi2 = new ServletHolder(new MyCGI());
       	holder_cgi2.setInitParameter("cgibinResourceBase", "cgi-bin");
       	holder_cgi2.setInitParameter("cgibinResourceBaseIsRelative","true");
       	context1.addServlet(holder_cgi2,"/cgi-bin2/*");

	ServletHolder holder_ctx2 = new ServletHolder(new SpitServlet());
	context2.addServlet(holder_ctx2, "/spit/*");
	
		ServletHolder holder_ctx3 = new ServletHolder(new DummyResponseServlet());
		context2.addServlet(holder_ctx3, "/dummyresponse/*");	
		
       	server.start();
       	server.join();
      }
 }
