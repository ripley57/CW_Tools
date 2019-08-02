/*
 *  Java Design Pattern Essentials - Second Edition, by Tony Bevis
 *  Copyright 2012, Ability First Limited
 *
 *  This source code is provided to accompany the book and is provided AS-IS without warranty of any kind.
 *  It is intended for educational and illustrative purposes only, and may not be re-published
 *  without the express written permission of the publisher.
 */

package com.jeremyc.model;

import java.io.*;

/**
 * JeremyC 31-07-2019
 *
 * From https://stackoverflow.com/questions/2273299/can-an-interface-extend-the-serializable-interface#2273344 :
 *
 * "Yes, you can extend the "Serializable" interface. If you do, all classes that implement the new subinterface 
 *  will also be implementing Serializable."
*/

public interface Engine extends Serializable {
    
    public int getSize();
    public boolean isTurbo();
    
}
