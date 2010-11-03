@no-txn
Feature: Shell user lists a user's contacts
  As a person using the shell
  I want to a user's contacts
  In order to see the contacts' names and numbers

  Scenario: When there are no contacts created
    Given a user with name "murilo" exists
    And "murilo" has an empty contact list
    When I list the contacts for the user with name "murilo"
    Then bell should tell me that "murilo" has an empty contact list

  Scenario: When there are contacts created
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" and number "1234123412" in his contact list
    And "murilo" has a contact with name "roberto" and number "9876987698" in his contact list
    When I list the contacts for the user with name "murilo"
    Then bell's output should contain /augusto (1234123412)/
    And bell's output should contain /roberto (9876987698)/

  Scenario: When there are contacts created and asked for the CSV format
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" and number "1234123412" in his contact list
    And "murilo" has a contact with name "roberto" and number "9876987698" in his contact list
    When I list the contacts for the user with name "murilo" in CSV format
    Then bell's output should contain /"augusto",1234123412/
    And bell's output should contain /"roberto",9876987698/
