package com.ubs.a6t.test.features.simple
import SimpleComponent
import UseSimpleComponent.MasterComponent

Feature UseSimpleComponent

As a "Tester"
I want to "Make sure that the grammar works with component screens that are used from other screens"
In order to "Ensure that the language is ok"

Scenario "ReUse components from asset folder"
	Given I am on the UseSimpleComponent screen 
	when I from the Name textfield I type "sda"
	and I from the Submit button I click 
	and I from the Title combo I select indices 1
	and I from the Title combo I select names "Mueller", "Meyer"
	and I from the Title combo I select values "Peter", "Rakete"