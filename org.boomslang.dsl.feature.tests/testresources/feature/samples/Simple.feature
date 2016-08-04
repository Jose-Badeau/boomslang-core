package samples 

import Simple


Feature Simple

	As a "Test User"
	I want to "Add some scenarios"
	In order to "Verify the grammar"
	
	Scenario "Hit all elements on the screen"
		Given I am on the Simple screen 
			when I from the Name textfield I type "asdasd"
			and I from the Title combo I select indices 1
			and I from the Title combo I select names "Mueller", "Meier", "Schmidt"
			and I from the Title combo I select values "Meier", "Mueller"
			and I from the Submit button I click 

