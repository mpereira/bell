@no-txn
Feature: Shell user removes a user
  As a person using the shell
  I want to remove users
  In order to keep my contact base updated

  Scenario: User removal attempt when given user name doesn't exist
    Given no user with name "murilo" exists
    When I remove the user with name "murilo"
    Then bell should tell me that there is no user with name "murilo"

  Scenario: User removal attempt when given user exists
    Given a user with name "murilo" exists
    When I remove the user with name "murilo"
    Then bell should tell me that the user "murilo" was removed

  Scenario: User removal attempt when given user has contacts
    Given a user with name "murilo" exists
    And "murilo" has a contact with name "selma" in his contact list
    When I remove the user with name "murilo"
    Then I should not have a contact with name "selma" in the database
