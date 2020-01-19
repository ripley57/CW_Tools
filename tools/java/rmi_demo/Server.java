/*
 * Copyright (c) 2004, Oracle and/or its affiliates. All rights reserved.
 *
 * https://docs.oracle.com/javase/7/docs/technotes/guides/rmi/hello/hello-world.html
 *
 * From the above link:
 * "Note: As of the J2SE 5.0 release, stub classes for remote objects no longer need to be 
 *  pregenerated using the rmic stub compiler, unless the remote object needs to support 
 *  clients running in pre-5.0 VMs. If your application needs to support such clients, you 
 *  will need to generate stub classes for the remote objects used in the application and 
 *  deploy those stub classes for clients to download." 
 */
package example.hello;

import java.rmi.registry.Registry;
import java.rmi.registry.LocateRegistry;
import java.rmi.RemoteException;
import java.rmi.server.UnicastRemoteObject;

public class Server implements Hello {

    public Server() {}

    public String sayHello() {
        return "Hello, world!";
    }

    public static void main(String args[]) {

        try {
            Server obj = new Server();
            Hello stub = (Hello) UnicastRemoteObject.exportObject(obj, 0);

            // Bind the remote object's stub in the registry
            //
            // From "Java Examples":
            // "(make the exported object) available for use by clients, by 
            // registering the object by name with a registry service. This
            // is usually done with the "java.rmi.Naming" class and the 
            // "rmiregistry" program. A server program may also act as its
            // own registry server by using the "LocateRegistry" class.
            //
            Registry registry = LocateRegistry.getRegistry();
            registry.bind("Hello", stub);

            System.err.println("Server ready");
        } catch (Exception e) {
            System.err.println("Server exception: " + e.toString());
            e.printStackTrace();
        }
    }
}
