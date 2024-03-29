/*
 *  Java Design Pattern Essentials - Second Edition, by Tony Bevis
 *  Copyright 2012, Ability First Limited
 *
 *  This source code is provided to accompany the book and is provided AS-IS without warranty of any kind.
 *  It is intended for educational and illustrative purposes only, and may not be re-published
 *  without the express written permission of the publisher.
 */

package com.jeremyc.db;

import java.util.*;


/**
 * JeremyC 31-07-2019
 *
 * At the moment, I don't see the benefit of extending java.util.EventObject
 * What extra does this give us? Do we need it?
 */

public class EntityEvent extends EventObject {
    
    private Object value;
    
    EntityEvent() {
        this(0, null); // used when restoring data
    }
    
    EntityEvent(Integer key, Object value) {
        super(key);
        this.value = value;
    }
    
    public Integer getKey() {
        return (Integer) getSource();
    }
    
    public Object getValue() {
        return value;
    }
    
}
