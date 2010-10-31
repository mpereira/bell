@no-txn
Feature: Shell user renames an user
  As a person using the shell
  I want to rename users
  In order to keep the user base updated

  Scenario: User renaming when there's no user with the source name
    Given no user with name "bob" exists
    And a user with name "john" exists
    When I rename "bob" to "john"
    Then bell should tell me that there is no user with name "bob"

  Scenario: User renaming when there's a user with the target name
    Given a user with name "bob" exists
    And a user with name "john" exists
    When I rename "bob" to "john"
    Then bell should tell me that the user "john" already exists

  Scenario: User renaming when there's a user with the source name and no user with the target name
    Given a user with name "bob" exists
    And no user with name "john" exists
    When I rename "bob" to "john"
    Then bell should tell me that the user "bob" was renamed to "john"
    And I should have the user "john" in the database
    And I should not have the user "bob" in the database
