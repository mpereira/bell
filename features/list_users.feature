@no-txn
Feature: Shell user lists the users
  As a person using the shell
  I want to list users
  In order to know whom I can associate contacts with

  Scenario: Listing users when no users are in the database
    Given no user exists
    When I list the users
    Then bell should tell me that there are no created users

  Scenario: Listing users when there is one user in the database
    Given a user with name "murilo" exists
    When I list the users
    Then the messenger should contain "murilo"

  Scenario: Listing users when there is more than one user in the database
    Given a user with name "murilo" exists
    And a user with name "augusto" exists
    When I list the users
    Then the messenger should contain "murilo"
    And the messenger should contain "augusto"