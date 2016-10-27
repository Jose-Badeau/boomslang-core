package com.ubs.a6t.test.features.simple
import SimpleComponent

Feature SimpleComponent

As a "Tester"
I want to "Make sure that the grammar works with component screens"
In order to "Ensure that the language is ok"

Scenario "Reference Elements inside a component"
	Given I am on the screen SimpleComponent
	when I from the Name textfield I type "BlaBlub"
	when I from the Title combo I select indices 1
	when I from the Title combo I select names "Meier", "Mueller"
	when I from the Title combo I select values "Rakete"
	when I from the Submit button I click 