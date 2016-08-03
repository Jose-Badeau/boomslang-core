/* XPECT_SETUP org.boomslang.dsl.feature.tests.validation.localsamples.ValidationTestXpectSimple    
 	ResourceSet {
   		ThisFile {}
   		File "Login.screen" {}
  	}
  END_SETUP
 */
package samples

Feature Login
	As a "registered gmail user"
	I want to "be able to authenticate with correct credentials"
	In order to "securely access my email"
	
	Scenario "Authenticate : successfully authenticate with correct credentials"
		Given I am on the Login screen
		// and the title is "Login"
		
		when I type "jose.badeau" into the Username textfield 
		and I type "123456" into the Password textfield 
		and I click the Submit button
		 
		then I am on the Login screen
		// TODO and the title is "Welcome" 
		and the Logout button is visible 
		//and the Logout button color equals blue
	
//	@param username 
//	@param password 
	Scenario "WrongCredentials : can not authenticate with wrong credentials"
		Given I am on the Login screen
									  
		when I type "jose.badeau" into the Username textfield 
		and I type "wrong" into the Password textfield 
		and I  click the Submit button
		
		then I am on the Login screen 
		and the Message text  equals "invalid username and/or password" 
		
//	@param username 
//	@param password 
	Scenario "BlockedUser : blocked user can not authenticate, even with correct credentials given" 
	    // TODO call WrongCredentials 3 times with @username, @password
		Given I am on the Login screen 

		when I type "username" into the Username textfield 
		and I type "password" into the Password textfield 
		and I click the Submit button 
		
		then I am on the Login screen 
		and the Message text equals "user blocked, too many failed login attempts"