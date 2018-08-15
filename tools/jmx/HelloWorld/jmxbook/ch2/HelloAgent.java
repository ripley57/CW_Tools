package jmxbook.ch2;

import javax.management.*;
import com.sun.jdmk.comm.*;

public class HelloAgent implements NotificationListener
{
	private MBeanServer mbs = null;

	public HelloAgent()
	{
		mbs = MBeanServerFactory.createMBeanServer( "HelloAgent" );
		HtmlAdaptorServer adapter = new HtmlAdaptorServer();
		HelloWorld hw = new HelloWorld();
		ObjectName adapterName = null;
		ObjectName helloWorldName = null;
		try
		{
			// Register our HelloWorld MBean with the MBeanServer.
			helloWorldName = new ObjectName( "HelloAgent:name=helloWorld1" );
			mbs.registerMBean( hw, helloWorldName );
			// Register to receive notifications.
			hw.addNotificationListener( this, null, null );

			// The Html adapter is also an MBean, so is registered in the same way.
			adapterName = new ObjectName( "HelloAgent:name=htmladapter,port=9092" );
			adapter.setPort( 9092 );
			mbs.registerMBean( adapter, adapterName );
			adapter.start();
		} 
		catch ( Exception e )
		{
			e.printStackTrace();
		}
	}

	// This will be called when a notification is being delivered.
	public void handleNotification(
		Notification notif, Object handback )
	{
		System.out.println( "Receiving notification..." );
		System.out.println( notif.getType() );
		System.out.println( notif.getMessage() );
	}

	public static void main( String args[] )
	{
		System.out.println( "HelloAgent is running" );
		HelloAgent agent = new HelloAgent();
	}
}
