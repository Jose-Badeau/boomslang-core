package com.ubs.a6t.test.features.simple
import MultiWidgetGroups


Feature MultiWidgetGroups

	As a "Test User"
	I want to "Check the use of multiple components in one screen"
	In order to "verify the language works as expected"
	
	Scenario "Test Use Of Multiple"
	Given I am on the MultiWidgetGroups screen 
	when I from the Login textfield I type "Login Credentials"
	and I  from the Password textfield I type "MySecretPassword"
	and I from the PasswordForgotten button I click 
	and I from the Register button I click 