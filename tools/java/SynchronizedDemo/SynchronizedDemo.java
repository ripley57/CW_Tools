import java.io.*;
import java.lang.management.*;

public class SynchronizedDemo {
	static public void main(String[] args) {
		SynchronizedDemo sd = new SynchronizedDemo();
		sd.runDemo();

		// Hopefully, we should see thread t2 stuck waiting for thread t1.
		dumpStacks();
	}

	void runDemo() {
		final UserSearchContext usc1 = new UserSearchContext();

		Thread t1 = new Thread(new Runnable() {
			public void run() { 
				System.out.println("Thread t1. About to call usc1.set()...");
				usc1.set();
			}
		});

		Thread t2 = new Thread(new Runnable() {
			public void run() {
				System.out.println("Thread t2. About to call usc1.get()...");
				usc1.get(); 
			}
		});

		t1.start();
		t2.start();

		//try { t1.join(); } catch (InterruptedException ex) { }
		//try { t2.join(); } catch (InterruptedException ex) { }
	}	
 
	class UserSearchContext {
		public synchronized void set() {
			System.out.println("Inside UserSearchContext.set()...");
			try {
				System.out.println("UserSearchCOntext.set(): Sleeping for 60 seconds...");
				Thread.sleep(1000 * 60);	// Sleep for 60 seconds.
			} 
			catch (InterruptedException ex) {
			}
		}

		public synchronized void get() {
			System.out.println("Inside UserSearchContext.get()...");
		}
	};

	private static void dumpStacks() {
    		final ThreadMXBean bean = ManagementFactory.getThreadMXBean( );
		long[] ids = bean.getAllThreadIds();
		ThreadInfo[] threads = bean.getThreadInfo(ids, 20);
		
		for (ThreadInfo ti : threads) {
   			StackTraceElement[] se = ti.getStackTrace();

 			Throwable t = new Throwable();
  			t.setStackTrace(se);
        
   			ByteArrayOutputStream bos = new ByteArrayOutputStream();
   			PrintStream ps = new PrintStream(bos, true);
        
   			ps.println(ti);
   			t.printStackTrace(ps);
   			ps.println();
        
   			System.out.println(bos.toString());
		}
	}
}
