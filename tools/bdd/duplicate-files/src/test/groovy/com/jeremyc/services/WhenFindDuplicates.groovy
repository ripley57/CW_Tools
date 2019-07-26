package com.jeremyc.services

import com.jeremyc.model.*
import com.jeremyc.services.*

import spock.lang.Specification

class WhenFindDuplicates extends Specification {
	
	def "should find duplicates in a single directory set"() {
		given: "a duplicate file finder service"
                DuplicatesService duplicatesService = new DuplicatesService()

		expect: "that all duplicate files identified are as expected"
		duplicatesService.findDuplicates(directorySet)[0] == expectedFiles
		
		where: "sample directory sets are"
		[testdescription,directorySet,expectedFiles] << new TestDataGenerator()
	}

}
