package com.jeremyc.services;

import java.io.File;
import java.io.IOException;

import java.util.Arrays;
import java.util.ArrayList;
import java.util.Iterator;
import java.util.List;

import org.codehaus.jackson.JsonNode;
import org.codehaus.jackson.map.ObjectMapper;

import com.jeremyc.model.*;


/*
** Custom iterator to generate data for our Spock tests.
*/

public class TestDataGenerator implements Iterator<Object[]>{

	private List<String>	   testdescriptions;
	private List<DirectorySet> directorySets;
	private List<DupFileSet>   expectedFiles;
	private int counter = 0;

        public TestDataGenerator() {
		testdescriptions	= new ArrayList<String>();
                directorySets		= new ArrayList<DirectorySet>();
                expectedFiles		= new ArrayList<DupFileSet>();

		// Input test data files.
		List<String> testFiles = Arrays.asList("test1.json","test2.json","test3.json");
		for (String f : testFiles) {
                	parse("src/test/resources/test-files/" + f);
		}
        }

	private void parse(String testFile) {
		try {
                        // JSON -> Object: https://www.javainterviewpoint.com/jackson-tree-model-jsonnode/

                        // Create ObjectMapper object.
                        ObjectMapper mapper = new ObjectMapper();
                        // Reading the json file.
                        JsonNode rootNode = mapper.readTree(new File(testFile));

			String description = rootNode.get("description").asText();
			testdescriptions.add(description);
			
			JsonNode dirSetNode = rootNode.get("dirset");
			JsonNode expectedNode = rootNode.get("expected");

			// Build input directory set
			String dirSetName = dirSetNode.get("name").asText();
			DirectorySet ds = new DirectorySet(dirSetName);
			JsonNode dirs = dirSetNode.get("dirs");
			for (JsonNode n : dirs) {
				DupDirectory dd = buildDupDirectory(n);
				ds.addNode(dd);		
			}
			directorySets.add(ds);

			// Build output expected files
			DupFileSet dfs = new DupFileSet();
			for (JsonNode n : expectedNode) {
				DupFile df = (DupFile)buildDupFile(n);
				dfs.add(df);
			}
			expectedFiles.add(dfs);

                } catch (IOException e) {
                        e.printStackTrace();
                }
	}

	private DupDirectory buildDupDirectory(JsonNode dir) {

		String dname = dir.get("name").asText();
		DupDirectory dd = new DupDirectory(dname);

		JsonNode files = dir.get("files");
		for (JsonNode f : files) {
			String ftype = f.get("type").asText();

			if (ftype.equals("FILE")) {
				dd.addNode(buildDupFile(f));
			}
		}

		return dd;
	}

	private DupNode buildDupFile(JsonNode n) {
		String name     = n.get("name").asText();
		String checksum = n.get("checksum").asText();
		return new DupFile(name,checksum);
	}

	@Override
	public boolean hasNext() {
		return counter < testdescriptions.size();
	}

	@Override
 	public Object[] next() {
                Object[] result = new Object[3];
		result[0] = testdescriptions.get(counter);
                result[1] = directorySets.get(counter);
                result[2] = expectedFiles.get(counter);
                counter++;
                return result;
        }

	@Override
	public void remove() {
		// not needed for this test
	}
}
