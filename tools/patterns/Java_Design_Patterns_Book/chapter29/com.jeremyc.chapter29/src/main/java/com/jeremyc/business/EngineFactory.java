/*
 *  Java Design Pattern Essentials - Second Edition, by Tony Bevis
 *  Copyright 2012, Ability First Limited
 *
 *  This source code is provided to accompany the book and is provided AS-IS without warranty of any kind.
 *  It is intended for educational and illustrative purposes only, and may not be re-published
 *  without the express written permission of the publisher.
 */

package com.jeremyc.business;

/**
 * JeremyC 31-07-2019.
 * NOTE: I relocated this factory class from the "model" package to the
 *       "business" package. Not sure if that's a good thing to do or not.
 *       One consequence is that I now need all these import statements.
*/
import com.jeremyc.model.Engine;
import com.jeremyc.model.StandardEngine;
import com.jeremyc.model.TurboEngine;


public class EngineFactory {
    
    public enum Type {STANDARD, TURBO};
    
    static Engine create(EngineFactory.Type type, int size) {
        if (type == Type.STANDARD) {
            return new StandardEngine(size);
        } else {
            return new TurboEngine(size);
        }
    }
    
    static Engine create(int size, boolean turbo) {
        return EngineFactory.create(turbo ? 
                        Type.TURBO : Type.STANDARD, size);
    }
    
    private EngineFactory() {}
    
}
