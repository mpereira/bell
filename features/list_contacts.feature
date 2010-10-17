@no-txn
Feature: Shell user lists the contacts
  As a person using the shell
  I want to list contacts
  In order to see the contacts' names and numbers

  Scenario: Listing all contacts
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" and number "1234123412" in his contact list
    Given a user with name "roberto" exists
    And "roberto" has a contact with name "selma" and number "9876987698" in his contact list
    When I list all contacts
    Then the output should contain "augusto (1234123412) - murilo"
    And the output should contain "selma (9876987698) - roberto"

  Scenario: Listing an user's empty contact list
    Given a user with name "murilo" exists
    When I list the contacts for the user with name "murilo"
    Then bell should tell me that the contact list of the user with name "murilo" is empty

  Scenario: Listing an user's contact list
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" and number "1234123412" in his contact list
    And "murilo" has a contact with name "roberto" and number "9876987698" in his contact list
    When I list the contacts for the user with name "murilo"
    Then the output should contain "augusto (1234123412)"
    And the output should contain "roberto (9876987698)"
