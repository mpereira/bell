@no-txn
Feature: Shell user creates a contact
  As a person using the shell
  I want to create contacts
  In order to associate calls from the phone bill to users

  Scenario: Creating a contact for a user that doesn't exist
    Given no user with name "murilo" exists
    When I create a contact with name "augusto" for the user with name "murilo"
    Then bell should tell me that there is no user with name "murilo"

  Scenario: Creating a duplicate contact for an existing user
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" in his contact list
    When I create a contact with name "augusto" for the user with name "murilo"
    Then bell should tell me that "murilo" already has "augusto" in his contact list

  Scenario: Creating a new contact for an existing user
    Given a user with name "murilo" exists
    When I create a contact with name "augusto" for the user with name "murilo"
    Then bell should tell me that the contact "augusto" was created for "murilo"
    And "murilo" should have "augusto" in his contact list

  Scenario: Creating contact with a name that's used in another user's contact list
    Given a user with name "murilo" exists
    And a user with name "roberto" exists
    And "roberto" has a contact with name "augusto" in his contact list
    When I create a contact with name "augusto" for the user with name "murilo"
    Then bell should tell me that the contact "augusto" was created for "murilo"
    And "murilo" should have "augusto" in his contact list

  Scenario: Creating contact with a number that's used by another contact
    Given a user with name "murilo" exists
    And a user with name "roberto" exists
    And "roberto" has a contact with number "1234567890" in his contact list
    When I create a contact with number "1234567890" for the user with name "murilo"
    Then bell should tell me that the number "1234567890" was already taken

  Scenario: Creating contact with a short phone number
    Given a user with name "murilo" exists
    When I create a contact with number "12345678" for the user with name "murilo"
    Then bell should tell me that the number "12345678" has a bad format

  Scenario: Creating contact with invalid characters in the phone number
    Given a user with name "murilo" exists
    When I create a contact with number "12ab56cd78" for the user with name "murilo"
    Then bell should tell me that the number "12ab56cd78" has a bad format
