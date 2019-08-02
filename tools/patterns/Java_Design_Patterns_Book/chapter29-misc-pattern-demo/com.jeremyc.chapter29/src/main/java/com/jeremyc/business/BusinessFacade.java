/*
 *  Java Design Pattern Essentials - Second Edition, by Tony Bevis
 *  Copyright 2012, Ability First Limited
 *
 *  This source code is provided to accompany the book and is provided AS-IS without warranty of any kind.
 *  It is intended for educational and illustrative purposes only, and may not be re-published
 *  without the express written permission of the publisher.
 */

package com.jeremyc.business;

import com.jeremyc.db.*;
import com.jeremyc.model.Engine;

import java.io.*;

/**
 * JeremyC 31-07-2019. The Facade pattern combines multiple interfaces
 *                     into one single, more easy to use, interface. 
 *
 * NOTE: An enum is used here to create a singleton. This means that the caller uses code
 *      like this:
 * 		BusinessFacade.INSTANCE.addEngine()
 *
 * The reason for using an Enum is that little code is required, and it also avoids using 
 * things such as "Synchronized", see:
 *
 * From https://www.journaldev.com/1377/java-singleton-design-pattern-best-practices-examples :
 * 	"Joshua Bloch suggests the use of Enum to implement Singleton design pattern, as Java 
 *	 ensures that any enum value is instantiated only once in a Java program. Since Java 
 *	 Enum values are globally accessible, so is the singleton."
 */

public enum BusinessFacade {
    
    INSTANCE;
    
    public Object[] getEngineTypes() {
        return EngineFactory.Type.values();
    }
    
    public Object[] getAllEngines() {
        return DatabaseFacade.INSTANCE.getAllEngines();
    }
    
    public Object addEngine(int size, Object type) {
        Engine engine = EngineFactory.create(size, type == EngineFactory.Type.TURBO);
        DatabaseFacade.INSTANCE.addEngine(engine);
        return engine;
    }
    
    public void saveEngines() throws IOException {
        DatabaseFacade.INSTANCE.saveEngines();
    }
    
    public void restoreEngines() throws IOException {
        DatabaseFacade.INSTANCE.restoreEngines();
    }
    
    public void addEngineListener(EntityListener listener) {
        DatabaseFacade.INSTANCE.addEngineListener(listener);
    }
    
    public void removeEngineListener(EntityListener listener) {
        DatabaseFacade.INSTANCE.removeEngineListener(listener);
    }
    
}
