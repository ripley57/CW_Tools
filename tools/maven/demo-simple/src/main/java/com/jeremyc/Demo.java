package com.jeremyc;

import java.io.File;
import java.io.FileNotFoundException;
import java.io.InputStream;
import java.io.IOException;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;

public class Demo {

	public static void main(String[] args) {
		System.out.println("testing, testing\n");
		new Demo().doIt();
	}

	public void doIt() {
		try {
			/*
			** JSON -> Object
			** https://www.javainterviewpoint.com/jackson-tree-model-jsonnode/
			*/

            		// Create ObjectMapper object
            		ObjectMapper mapper = new ObjectMapper();

           		// Reading the json file (in our jar!)
            		//JsonNode rootNode = mapper.readTree(new File("dirsets.json"));
            		JsonNode rootNode = mapper.readTree(getFileInJar("dirsets.json"));

            		JsonNode nameNode = rootNode.get("name");
            		System.out.println("Name : "+nameNode.asText());

        	} catch (IOException e) {
            		e.printStackTrace();
        	}
    	}

	// We need to do this to read that's inside our jar.
        private InputStream getFileInJar(String filename) throws FileNotFoundException {
                return this.getClass().getClassLoader().getResourceAsStream(filename);
        }

}
