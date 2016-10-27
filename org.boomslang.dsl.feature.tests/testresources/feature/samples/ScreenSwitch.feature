package com.ubs.a6t.test.features.simple
import WidgetGroupInWidgetGroup
import MultiComponent
import SimpleComponent
import SimpleContactComponent


Feature ScreenSwitch

	As a "Test User"
	I want to "Add some scenarios"
	In order to "Verify the grammar"
	
	Scenario "Hit all elements on the screen"
		Given I am on the screen WidgetGroupInWidgetGroup
		when I from the Yes button I click 
		then I am on the screen MultiComponent 
		when I from the EMail textfield I type "DSFDSF"
		then I am on the screen Simple
		when I from the Name textfield I type "BAFD"
		then I am on the screen WidgetGroupInWidgetGroup 
		when I from the Clear button I click