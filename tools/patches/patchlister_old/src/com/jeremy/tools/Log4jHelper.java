package com.jeremy.tools;

import org.apache.log4j.*;
 
public class Log4jHelper {
	static Logger logger = Logger.getLogger(Log4jHelper.class);
    
	// It is not possible to override Log4j properties on the command-line.
	// For example, this won't work: java -Dlog4j.logger.CWTools=INFO -jar cwtools.jar
	public static void configureLog4jFromSystemProperties()
	{	
		final String LOGGER_PREFIX = "log4j.logger.";
		for (String propertyName : System.getProperties().stringPropertyNames()) {
			if (propertyName.startsWith(LOGGER_PREFIX)) {
      				String loggerName = propertyName.substring(LOGGER_PREFIX.length());
      				String levelName = System.getProperty(propertyName, "");
					logger.debug("loggerName=" + loggerName + ", levelName=" + levelName);
      				Level level = Level.toLevel(levelName); 
      				if (!"".equals(levelName) && !levelName.toUpperCase().equals(level.toString())) {
        				logger.error("Skipping unrecognized log4j log level " + levelName + ": -D" + propertyName + "=" + levelName);
        				continue;
      				}
      				logger.debug("Setting " + loggerName + "=" + level.toString());
     				Logger.getLogger(loggerName).setLevel(level);
    			}
  		}
	}
}
