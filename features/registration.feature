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

	Scenario: Missing email address
		Given I am on the signup page
		And I fill in "person_password" with "one ring to rule them all"
		And I fill in "person_password_confirmation" with "one ring to rule them all"
		And I press "Sign up"
		Then I should see "Email can't be blank"

	Scenario: Missing password
		Given I am on the signup page
		And I fill in "person_email" with "frodo@baggins.net"
		And I fill in "person_password_confirmation" with "one ring to rule them all"
		And I press "Sign up"
		Then I should see "Password is too short"

	Scenario: Bad password confirmation
		Given I am on the signup page
		And I fill in "person_email" with "frodo@baggins.net"
		And I fill in "person_password" with "one ring to rule them all"
		And I fill in "person_password_confirmation" with "the ring to rule them all"
		And I press "Sign up"
		Then I should see "Password doesn't match confirmation"
