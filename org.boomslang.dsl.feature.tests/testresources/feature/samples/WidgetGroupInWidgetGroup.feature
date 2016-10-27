package com.ubs.a6t.test.features.simple
import WidgetGroupInWidgetGroup


Feature WidgetGroupInWidgetGroup

	As a "Test User"
	I want to "Add some scenarios"
	In order to "Verify the grammar"
	
	Scenario "Hit all elements on the screen"
		Given I am on the screen WidgetGroupInWidgetGroup
		when I from the Yes button I click 
		and I from the No button I click  
		and I from the Clear button I click 
		and I from the Password textfield I type "******"
		and I from the Submit button I click 
		and I from the UserName textfield I type "UserName"
		and I from the Options combo I select indices 1
		