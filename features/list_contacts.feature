@no-txn
Feature: Shell user lists the contacts
  As a person using the shell
  I want to list contacts
  In order to see the contacts' names and numbers

  Scenario: Listing all contacts
    Given a user with name "murilo" exists
    And a user with name "roberto" exists
    And "murilo" has a contact with name "selma" in his contact list
    And "roberto" has a contact with name "augusto" in his contact list
    When I list all contacts
    Then the output should contain "augusto"
    And the output should contain "selma"

  Scenario: Listing user contacts when his contact list is empty
    Given a user with name "murilo" exists
    When I list the contacts for the user with name "murilo"
    Then bell should tell me that the contact list of the user with name "murilo" is empty

  Scenario: Listing user contacts when his contact list is not empty
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" in his contact list
    When I list the contacts for the user with name "murilo"
    Then the output should contain "augusto"
