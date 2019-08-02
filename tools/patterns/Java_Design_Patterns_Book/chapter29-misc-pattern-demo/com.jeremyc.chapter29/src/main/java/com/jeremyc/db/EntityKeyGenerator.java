/*
 *  Java Design Pattern Essentials - Second Edition, by Tony Bevis
 *  Copyright 2012, Ability First Limited
 *
 *  This source code is provided to accompany the book and is provided AS-IS without warranty of any kind.
 *  It is intended for educational and illustrative purposes only, and may not be re-published
 *  without the express written permission of the publisher.
 */

package com.jeremyc.db;


/**
 * JeremyC 31-07-2019.
 * Note again that we are using Java enum to create a Singleton.
 */

public enum EntityKeyGenerator {
    
    ENGINE;
    
    private int nextKey;
    
    synchronized int getNextKey() {
        return ++nextKey;
    }
    
}
