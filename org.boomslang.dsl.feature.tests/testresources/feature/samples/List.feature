package samples

Feature List 
	As a "boomslang user"
	I want to "be able to manipulate lists"
	In order to "select and check list items"
	
	Scenario "selection : select a items from a list"
		Given I am on the List screen
				
		and I select the names "Switzerland", "Germany" from the Countries list
		and I select the values "ch", "de" from the Countries list
		and I select the indices 1, 2 from the Countries list
		
		then the names "Switzerland", "Germany" from the Countries list are selected
		and the values "ch", "de" from the Countries list are selected 
		and the indices 1, 2 from the Countries list are selected
		
	Scenario "existence : assert that items exist"
		Given I am on the List screen
		
		then the Countries list contains the values "ch", "de"  
		and the Countries list contains the names "Switzerland", "Germany"
		and the Countries list contains the indices 1, 2
		
		
		