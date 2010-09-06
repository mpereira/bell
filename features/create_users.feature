@no-txn
Feature: Shell user creates a user
  As a person using the shell
  I want to create users
  In order to figure out the owners of phone bill calls

  Scenario: User creation attempt when given user doesn't exist
    Given no user with name "murilo" exists
    When I run bell with "user create murilo"
    Then bell should tell me that a user with name "murilo" was created
    And I should have the user "murilo" in the database

  Scenario: User creation attempt when given user already exists
    Given a user with name "murilo" exists
    When I run bell with "user create murilo"
    Then bell should tell me that the user "murilo" already exists
