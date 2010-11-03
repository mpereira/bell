@no-txn
Feature: Shell user lists users
  As a person using the shell
  I want to list users
  In order to know the names I can associate contacts with

  Scenario: When no users are in the database
    Given no user exists
    When I list all users
    Then bell should tell me that there are no created users

  Scenario: When there is one user in the database
    Given a user with name "murilo" exists
    When I list all users
    Then bell's output should contain "murilo"

  Scenario: When there is more than one user in the database
    Given a user with name "murilo" exists
    And a user with name "augusto" exists
    When I list all users
    Then bell's output should contain "murilo"
    And bell's output should contain "augusto"
