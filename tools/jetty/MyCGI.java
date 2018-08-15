//
// MyCGI
//
// An extension to class CGI that extracts any GET request query string.
// Using CGI with a query string results in a 404 error when invoking the
// end CGI executable, because the query string is being considered as particular
// of the executable file path. This class MyCGI strips the query string.
//
// JeremyC 1-8-2018 
//

package org.eclipse.jetty.servlets;

/*
import java.io.File;
*/

import java.io.IOException;

/*
import java.io.InputStream;
import java.io.OutputStream;
import java.io.OutputStreamWriter;
import java.io.Writer;
import java.util.Enumeration;
import java.util.HashMap;
import java.util.Locale;
import java.util.Map;
*/

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

/*
import org.eclipse.jetty.http.HttpMethods;
import org.eclipse.jetty.util.IO;
import org.eclipse.jetty.util.MultiMap;
import org.eclipse.jetty.util.StringUtil;
import org.eclipse.jetty.util.UrlEncoded;
*/

import org.eclipse.jetty.util.log.Log;
import org.eclipse.jetty.util.log.Logger;

public class MyCGI extends CGI
{
	private static final Logger LOG = Log.getLogger(MyCGI.class);
	  
    public void init() throws ServletException
    {
		super.init();
     }

    public void service(HttpServletRequest req, HttpServletResponse res) throws ServletException, IOException
    {
		LOG.info("**** Inside MyCGI service() !");
		LOG.info("**** querystring=" + req.getQueryString());
		LOG.info("**** method=" + req.getMethod());
		super.service(req, res);
    }
}
