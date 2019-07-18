package com.manning.spock.warehouse;

import javax.swing.JDialog;
import javax.swing.JFrame;
import javax.swing.SwingUtilities;
import javax.swing.UIManager;

import org.springframework.context.support.AbstractApplicationContext;
import org.springframework.context.support.ClassPathXmlApplicationContext;

import com.manning.spock.warehouse.gui.MainWindow;

public class Launcher {

	/**
	 * @param args
	 */
	public static void main(String[] args) {

		try {
			UIManager.setLookAndFeel(UIManager.getSystemLookAndFeelClassName());
		} catch (Exception e) {
			e.printStackTrace();
		}

		JFrame.setDefaultLookAndFeelDecorated(true);
		JDialog.setDefaultLookAndFeelDecorated(true);
		
		final AbstractApplicationContext  context = new ClassPathXmlApplicationContext(new String[] {"spring-context.xml"});
		// JeremyC 17-07-2019. spring-context.xml is being included by Maven in our single jar, but cannot find the Spring context file.
		// From: https://stackoverflow.com/questions/6303242/loading-spring-application-context-files-that-are-inside-a-jar-in-classpath#6304113
		//final AbstractApplicationContext  context = new ClassPathXmlApplicationContext("classpath*:**/spring-context.xml");
		
		
		// Make sure that db is closed properly when shutting down
		context.registerShutdownHook();
		
		SwingUtilities.invokeLater(new Runnable() {

			@Override
			public void run() {
				MainWindow mainWindow = context.getBean("mainWindow", MainWindow.class);
				mainWindow.setVisible(true);

			}
		});

	}
}
