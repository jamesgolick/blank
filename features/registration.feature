Feature: Registration
In order to interact with the system
The site's owner
Wants people to register
So that actions on the site aren't anonymous

	Scenario: Register the old-fashioned way
		Given I am on the signup page
		And I fill in "person_email" with "frodo@baggins.net"
		And I fill in "person_password" with "one ring to rule them all"
		And I fill in "person_password_confirmation" with "one ring to rule them all"
		And I press "Sign up"
		Then I should be on the homepage
		And I should see "Thanks for signing up!"
