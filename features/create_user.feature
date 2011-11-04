@no-txn
Feature: Shell user creates a user
  As a person using the shell
  I want to create users
  In order to associate phone bill calls and contact lists to a name

  Scenario: When the given user name isn't taken
    Given no user with name "murilo" exists
    When I create a user with name "murilo"
    Then bell should tell me that a user with name "murilo" was created
    And I should have the user "murilo" in the database

  Scenario: When the given user name is already taken
    Given a user with name "murilo" exists
    When I create a user with name "murilo"
    Then bell should tell me that the user "murilo" already exists
