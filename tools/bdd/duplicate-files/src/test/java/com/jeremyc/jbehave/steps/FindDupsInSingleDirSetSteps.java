package com.jeremyc.jbehave.steps;

import com.jeremyc.services.*;
import com.jeremyc.model.*;

import org.jbehave.core.annotations.Given;
import org.jbehave.core.annotations.Pending;
import org.jbehave.core.annotations.Then;
import org.jbehave.core.annotations.When;
import org.joda.time.LocalTime;

import java.util.List;

import static org.fest.assertions.Assertions.assertThat;


public class FindDupsInSingleDirSetSteps {

    List<String> calculatedDupFileList;
    DirectorySet inputDirSet;

    @Given("a directory set consisting of directory $dirA containing file $file1 with checksum $checksum1, file $file2 with checksum $checksum2, and file $file3 with checksum $checksum3")
    public void givenDirectorySet(String dirA,
                                  String file1,	String checksum1,
				  String file2,	String checksum2,
                                  String file3,	String checksum3) {

	DupNode f1 = new DupFile(file1, checksum1);
	DupNode f2 = new DupFile(file2, checksum2);
	DupNode f3 = new DupFile(file3, checksum3);

	DupNode dA  = new DupDirectory(dirA);
	dA.addNode(f1);
	dA.addNode(f2);
	dA.addNode(f3);

	inputDirSet = new DirectorySet("test");
	inputDirSet.addNode(dA);
    }

    @When("I want to list duplicates")
    @Pending
    public void whenIListDuplicates() {
	/*
	** TODO: Implement DuplicateFilesService interface.
	*/
	//DuplicateFilesService duplicateFilesService = new DuplicateFilesService();
	//calculatedDupFileList = duplicateFilesService.findDuplicates(inputDirSet);
    }

    @Then("the only files listed should be: $expectedFileList")
    public void shouldBeListed(List<String>  expectedFileList) {
	assertThat(calculatedDupFileList).isEqualTo(expectedFileList);
    }
}
