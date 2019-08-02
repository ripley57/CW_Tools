/*
 *  Java Design Pattern Essentials - Second Edition, by Tony Bevis
 *  Copyright 2012, Ability First Limited
 *
 *  This source code is provided to accompany the book and is provided AS-IS without warranty of any kind.
 *  It is intended for educational and illustrative purposes only, and may not be re-published
 *  without the express written permission of the publisher.
 */

package com.jeremyc.db;

import java.io.*;
import java.util.*;


/**
 * JeremyC 31-07-2019
 *
 * This class is basically a holder of object entities, holding them inside
 * a Map, and accessible by a (Integer) key.
 *
 * The class also includes methods for interested classes to register to be
 * notified (Observer pattern) when a single entity is added, or all of the
 * entities have been updated/restored.
*/

public class EntityTable implements Serializable {
    
    private EntityKeyGenerator keyGenerator;
    private Map<Integer, Object> entities;

    /**
    * JeremyC 2-8-2019. We need to exclude this from serialization, because it references AWT
    * components that are not serializable, and they give an error when we try to serialize
    * this class! Fortunately, we don't need to serialize this member anyway.
    *
    * Regarding "transient", see https://stackoverflow.com/questions/14582440/how-to-exclude-field-from-class-serialization-in-runtime#14582551
    **/
    private transient Collection<EntityListener> listeners;
    
    EntityTable(EntityKeyGenerator keyGenerator) {
        this.keyGenerator = keyGenerator;
        entities = new HashMap<Integer, Object>();
        listeners = new ArrayList<EntityListener>();
    }
    
    Object getByKey(Integer key) {
        return entities.get(key);
    }
    
    Collection<Object> getAll() {
        return entities.values();
    }
    
    Integer addEntity(Object value) {
        Integer key = keyGenerator.getNextKey();
        entities.put(key, value);
        fireEntityAdded(key, value);
        return key;
    }
    
    void restore(EntityTable restoredTable) {
        entities.clear();
        entities.putAll(restoredTable.entities);
        fireEntityRestored();
    }
    
    void addEntityListener(EntityListener listener) {
        listeners.add(listener);
    }
    
    void removeEntityListener(EntityListener listener) {
        listeners.remove(listener);
    }
    
    void fireEntityAdded(Integer key, Object value) {
        EntityEvent event = new EntityEvent(key, value);
        for (EntityListener listener : listeners) {
            listener.entityAdded(event);	// JeremyC 31-07-2019. Observer pattern.
        }
    }
    
    void fireEntityRestored() {
        EntityEvent event = new EntityEvent();
        for (EntityListener listener : listeners) {
            listener.entityRestored(event);	// JeremyC 31-07-2019. Observer pattern.
        }
    }
    
}
