package com.ubs.a6t.test.features.simple
import MultiComponent
import SimpleContactComponent
import SimpleComponent
import MultiComponentWithOwnWidgets


Feature MultiComponentWithOwnWidgets

	As a "Test User"
	I want to "Check the use of multiple components in one screen"
	In order to "verify the language works as expected"
	
	Scenario "Test Use Of Multiple"
	Given I am on the screen MultiComponentWithOwnWidgets 
	when I from the EMail textfield  I type "john.doe@test.com"
	and I from the Name textfield I type "John Doe"
	and I from the PhoneNumber textfield I type "+ 41 225587"
	and I from the Title combo I select names "Mr."
	and I from the Title combo I select indices 1
	and I from the Title combo I select values "Mr."
	and I from the Validate button I click 
	and I from the Submit button I click 
	and I from the UserName textfield I type "Username"
	and I from the Password textfield I type "****"