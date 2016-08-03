package samples

Feature Tree 
	As a "registered gmail user"
	I want to "be able to authenticate with correct credentials"
	In order to "securely access my email"
	
	Scenario Authenticate : successfully authenticate with correct credentials
		Given I am on the Table screen
		
		when I type "1d" into the "work logged" cells from the Worklog table (where the "status" cells equal "open") 
		and I click the "work logged" cells from the WorkLog table (where the "status" cells equal "open")
	
		then the "work logged" cells from the Worklog table (where the "status" cells equal "open") contain "1d"  
