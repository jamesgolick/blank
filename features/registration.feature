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
    And the "Password" field should be empty
    And the "Confirm Password" field should be empty

  Scenario: Missing password
    Given I am on the signup page
    And I fill in "person_email" with "frodo@baggins.net"
    And I fill in "person_password_confirmation" with "one ring to rule them all"
    And I press "Sign up"
    Then I should see "Password is too short"
    And the "Email" field should contain "frodo@baggins.net"
    And the "Password" field should be empty
    And the "Confirm Password" field should be empty
  
  Scenario: Bad password confirmation
    Given I am on the signup page
    And I fill in "person_email" with "frodo@baggins.net"
    And I fill in "person_password" with "one ring to rule them all"
    And I fill in "person_password_confirmation" with "the ring to rule them all"
    And I press "Sign up"
    Then I should see "Password doesn't match confirmation"
    And the "Email" field should contain "frodo@baggins.net"
    And the "Password" field should be empty
    And the "Confirm password" field should be empty

  Scenario: Using OpenID
    Given I am on the signup page
    And I fill in "openid_url" with "http://frodo.myopenid.com"
    And I press "Sign up with OpenID"
    Then I should be redirected to "http://www.myopenid.com/server"
