@no-txn
Feature: Shell user removes a user
  As a person using the shell
  I want to remove users
  In order to keep my database updated

  Scenario: Removing a user that doesn't exist
    Given no user with name "murilo" exists
    When I remove the user with name "murilo"
    Then bell should tell me that there is no user with name "murilo"

  Scenario: Removing an existing user
    Given a user with name "murilo" exists
    When I remove the user with name "murilo"
    Then bell should tell me that the user "murilo" was removed

  Scenario: Removing an existing user which has contacts
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "selma" in his contact list
    When I remove the user with name "murilo"
    Then I should not have a contact with name "selma" in the database
