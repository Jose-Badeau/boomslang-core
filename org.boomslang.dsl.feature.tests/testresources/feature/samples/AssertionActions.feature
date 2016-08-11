package com.ubs.a6t.test.features.simple
import Simple
import SimpleContactComponent


Feature Table

	As a "Language engineer"
	I want to "check the assertion actions"
	In order to "verify that the grammar is correct"
	
	Scenario "Assertion Handling"
	Given I am on the Simple screen 
	
	when I from the Submit button I click 
	then the Name textfield not equals ""
	and the Name textfield equals "Something"
	and the Name textfield is locked
	and the Name textfield is not visible
	and the Name textfield matches "Some"
	and the Name textfield property height contains 12
	and the Name textfield property height equals "122"
	and the Name textfield property height matches "22"
	and the Name textfield property height not equals "77"
	and the Submit button equals "Blub"
	and the Submit button not equals "Bl"
	and the Submit button property name equals "Submit"
	and the Title combo selected entry contains "asd"
	and the Title combo selected entry index equals 3
	
	
	