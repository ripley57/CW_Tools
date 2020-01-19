/*
 * Copyright (c) 2004, Oracle and/or its affiliates. All rights reserved.
 *
 * https://docs.oracle.com/javase/7/docs/technotes/guides/rmi/hello/hello-world.html
 *
 */
package example.hello;

import java.rmi.Remote;
import java.rmi.RemoteException;

public interface Hello extends Remote {
    String sayHello() throws RemoteException;
}
