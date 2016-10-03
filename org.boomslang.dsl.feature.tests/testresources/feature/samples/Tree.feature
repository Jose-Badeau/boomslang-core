package feature.samples
import SimpleTree

Feature Tree
	As a "Language engineer"
	I want to "check the tree handling"
	In order to "verify that the grammar is correct"
	
	Scenario "Select tree node"
		Given I am on the SimpleTree screen
		when I from the Tree1 tree I activate the node "1">"2">"3"
		then the Tree1 tree selected entry equals "Tree Label 1"
		
		
