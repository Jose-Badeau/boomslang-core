package com.ubs.a6t.test.features.simple
import Simple


Feature Table

	As a "Language engineer"
	I want to "check the table handling"
	In order to "verify that the grammar is correct"
	
	Scenario "Click Table Handling"
	Given I am on the screen Simple 
	
	when I from the Adress table I click cell where row equals "Test", 
												and column matches "some name",
												and row not equals "Another Test",
												and column contains "ome na",
												and row index equals 1
	
	Scenario "Select Table Handling"
	Given I am on the screen Simple 
	
	when I from the Adress table I select cell where row equals "Test", 
												and column matches "some name",
												and row not equals "Another Test",
												and column contains "ome na",
												and row index equals 1
												
	Scenario "Type Table Handling"
	Given I am on the screen Simple 
	
	when I from the Adress table I type "Foo" in the  cell where row equals "Test", 
														and column matches "some name",
														and row not equals "Another Test",
														and column contains "ome na",
														and row index equals 1
														
	Scenario "DoubleClick Table Handling"
	Given I am on the screen Simple
	
	when I from the Adress table I double click cell where row equals "Test", 
														and column matches "some name",
														and row not equals "Another Test",
														and column contains "ome na",
														and row index equals 1
														
	Scenario "Check Table Handling"
	Given I am on the screen Simple
	
	when I from the Adress table I check cell where row equals "Test", 
														and column matches "some name",
														and row not equals "Another Test",
														and column contains "ome na",
														and row index equals 1
													
												
												
	