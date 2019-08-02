/*
 *  Java Design Pattern Essentials - Second Edition, by Tony Bevis
 *  Copyright 2012, Ability First Limited
 *
 *  This source code is provided to accompany the book and is provided AS-IS without warranty of any kind.
 *  It is intended for educational and illustrative purposes only, and may not be re-published
 *  without the express written permission of the publisher.
 */

package com.jeremyc.ui;

import java.awt.*;
import java.awt.event.*;
import java.io.*;
import java.util.*;
import javax.swing.*;

import com.jeremyc.business.*;
import com.jeremyc.db.*;


public class ManageEnginesPanel extends JPanel implements EntityListener {
    
    private Frame owner;
    private EngineListModel enginesModel;
    
    ManageEnginesPanel(final Frame owner) {
        super(new BorderLayout());
        this.owner = owner;
        
        // Scrollable list of engines
        enginesModel = new EngineListModel();
        add(new JScrollPane(new JList(enginesModel)), BorderLayout.CENTER);
        
        // Button to add engine
        JPanel buttonPanel = new JPanel(new FlowLayout());
        JButton buildEngineButton = new JButton("Build Engine");
        buildEngineButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                new BuildEngineDialog(owner).show();
            }
        });
        buttonPanel.add(buildEngineButton);

        // Button to save all engines
        JButton saveButton = new JButton("Save");
        saveButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                try {
                    BusinessFacade.INSTANCE.saveEngines();
                } catch (IOException ex) {
                    JOptionPane.showMessageDialog(ManageEnginesPanel.this, ex, "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });
        buttonPanel.add(saveButton);

	// Button to load all engines
        JButton restoreButton = new JButton("Restore");
        restoreButton.addActionListener(new ActionListener() {
            public void actionPerformed(ActionEvent event) {
                try {
                    BusinessFacade.INSTANCE.restoreEngines();
                } catch (IOException ex) {
                    JOptionPane.showMessageDialog(ManageEnginesPanel.this, ex, "Error", JOptionPane.ERROR_MESSAGE);
                }
            }
        });
        buttonPanel.add(restoreButton);
        
        add(buttonPanel, BorderLayout.SOUTH);
    }

    // JeremyC 31-07-2019. Observer pattern. Our persistence layer calls this.
    // Here we add a new engine option to our list widget.
    public void entityAdded(EntityEvent event) {
        enginesModel.engineAdded(event.getValue());
    }

    // JeremyC 31-07-2019. Observer pattern. Our persistence layer calls this.
    // Here we reload all engine options into our list widget.
    public void entityRestored(EntityEvent event) {
        enginesModel.loadEngines();
    }
    
    
    // Inner class: ListModel for engines
    private class EngineListModel extends DefaultListModel {
        
        private java.util.List<Object> engines;
        
        EngineListModel() {
            engines = new ArrayList<Object>();
            loadEngines();
        }
     
	// Load this listbox with our persisted engines.   
        void loadEngines() {
            engines.clear();
            engines.addAll( Arrays.asList(BusinessFacade.INSTANCE.getAllEngines()));
            fireContentsChanged(this, 0, engines.size() - 1);	// Refresh this listbox.
        }
        
	@Override
        public Object getElementAt(int index) {
            return engines.get(index);
        }

        @Override
        public int getSize() {
            return engines.size();
        }
        
        void engineAdded(Object engine) {
            engines.add(engine);
            fireContentsChanged(this, 0, engines.size() - 1); // Refresh this listbox.
        }
    }

}
