package com.jeremyc.services

import spock.lang.*

import com.jeremyc.model.*


/*
** Test our Spock custom iterator for generating sample test data.
*/

@Ignore
class TestDataGeneratorSpec extends Specification {

	@Unroll("Description: #testdescription")
	def "Test custom iterator"() {
		given: "a duplicate file finder service"
                DuplicatesService duplicatesService = new DuplicatesService()

		expect: "that all duplicate files identified are as expected"
		duplicatesService.findDuplicates(directorySet)[0] == expectedFiles
		
		where: "sample directory sets are"
		[testdescription,directorySet,expectedFiles] << new TestDataGenerator()
	}
}

