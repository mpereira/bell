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
    When I run bell with "contact list"
    Then the messenger should contain "augusto"
    And the messenger should contain "selma"

  Scenario: Listing contacts from a given user
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" in his contact list
    When I run bell with "contact list murilo"
    And the messenger should contain "augusto"
