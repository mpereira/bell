Feature: Shell user requests an user report
  As a person using the shell
  I want to see user reports
  In order to see how much a specific user spent on phone calls

  Scenario: Requesting a user report for a non-existing file
    When I request a user report for a non-existing file
    Then bell should tell me that the path passed does not exist

  Scenario: Requesting a user report for a directory
    When I request a user report for a directory
    Then bell should tell me that the path passed is a directory

  Scenario: Requesting a user report for a non phone bill file
    When I request a user report for a non phone bill file
    Then bell should tell me that the path passed is a non phone bill file

  Scenario: Requesting a user report for an invalid phone bill file
    When I request a user report for an invalid phone bill file
    Then bell should tell me that the path passed is an invalid phone bill
