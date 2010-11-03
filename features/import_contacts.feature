@no-txn
Feature: Shell user imports a csv file of contacts
  As a person using the shell
  I want to import contacts
  In order to associate phone calls to users

  Scenario: Requesting a contact import using a non-existing file
    When I request a contact import for a non-existing file
    Then bell should tell me that the path passed does not exist

  Scenario: Requesting a contact import using a directory
    When I request a contact import for a directory
    Then bell should tell me that the path passed is a directory

  Scenario: Requesting a contact import using an invalid contacts file
    When I request a contact import for an invalid contacts file
    Then bell should tell me that the path passed is an invalid contacts file

  Scenario: Requesting a contact import for an user
    Given a user with name "earl" exists
    And "earl" has an empty contact list
    When I request a contact import for the user named "earl"
    Then "earl" should have "john" in his contact list
    And "earl" should have "bob" in his contact list
