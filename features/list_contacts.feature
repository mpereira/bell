@no-txn
Feature: Shell user lists the contacts
  As a person using the shell
  I want to list contacts
  In order to see the contacts' names and numbers

  Scenario: When there are no created contacts
    Given no created contacts
    When I list all contacts
    Then bell should tell me that there are no created contacts

  Scenario: When there are created contacts
    Given a user with name "murilo" exists
    And a user with name "roberto" exists
    And "murilo" has a contact with name "augusto" and number "1234123412" in his contact list
    And "roberto" has a contact with name "selma" and number "9876987698" in his contact list
    When I list all contacts
    Then bell's output should contain "augusto (1234123412) - murilo"
    And bell's output should contain "selma (9876987698) - roberto"

  Scenario: Listing an user's empty contact list
    Given a user with name "murilo" exists
    When I list the contacts for the user with name "murilo"
    Then bell should tell me that the contact list of the user with name "murilo" is empty

  Scenario: Listing an user's contacts
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" and number "1234123412" in his contact list
    And "murilo" has a contact with name "roberto" and number "9876987698" in his contact list
    When I list the contacts for the user with name "murilo"
    Then bell's output should contain /augusto (1234123412)/
    And bell's output should contain /roberto (9876987698)/

  Scenario: Listing an user's contacts in CSV format
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "augusto" and number "1234123412" in his contact list
    And "murilo" has a contact with name "roberto" and number "9876987698" in his contact list
    When I list the contacts for the user with name "murilo" in CSV format
    Then bell's output should contain /"augusto",1234123412/
    And bell's output should contain /"roberto",9876987698/
