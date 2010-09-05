@no-txn
Feature: List contacts
  As a person using the shell
  I want to list contacts
  In order to make sure they are related to their respective users

  Scenario: Listing all contacts
    Given the user named "murilo" exists
    And the user named "roberto" exists
    And "murilo" has a contact with name "selma" in his contact list
    And "roberto" has a contact with name "augusto" in his contact list
    When I run bell with "contact list"
    Then the messenger should contain "augusto"
    And the messenger should contain "selma"

  Scenario: Listing contacts from a given user
    Given the user named "murilo" exists
    And "murilo" has a contact with name "augusto" in his contact list
    When I run bell with "contact list murilo"
    And the messenger should contain "augusto"
