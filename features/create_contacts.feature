@no-txn
Feature: Create contacts
  As a person using the shell
  I want to create contacts
  In order to know the owner of a given call in the phone bill

  Scenario: Creating a contact for a user that doesn't exist
    Given no user named "murilo" exists
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell that the user "murilo" doesn't exist

  Scenario: Creating a duplicate contact for an existing user
    Given the user named "murilo" exists
    And "murilo" has a contact with name "augusto" in his contact list
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell me that "murilo" already has "augusto" in his contact list

  Scenario: Creating contact when it doesn't exist for an existing user
    Given the user named "murilo" exists
    And "murilo" doesn't have a contact with name "augusto" in his contacts
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell me that the contact "augusto" was created for "murilo"
    And "murilo" should have "augusto" in his contact list

  Scenario: Creating contact when it's in another user contact list
    Given the user named "murilo" exists
    And the user named "roberto" exists
    And "murilo" doesn't have a contact with name "augusto" in his contacts
    And "roberto" has a contact with name "augusto" in his contact list
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell me that the contact "augusto" was created for "murilo"
    And "murilo" should have "augusto" in his contact list

  Scenario: Creating contact when the number given is already taken
    Given the user named "murilo" exists
    And the user named "roberto" exists
    And "murilo" doesn't have a contact with name "augusto" in his contacts
    And "roberto" has a contact with name "augusto" and number "1234567890" in his contact list
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell me that the number "1234567890" was already taken
