Feature: Shell user requests a full report
  As a person using the shell
  I want to show full reports
  In order to see how much each user spent on phone calls

  Scenario: Requesting a full report for a non-existing file
    When I request a full report for a non-existing file
    Then bell should tell me that the path passed does not exist

  Scenario: Requesting a full report for a directory
    When I request a full report for a directory
    Then bell should tell me that the path passed is a directory

  Scenario: Requesting a full report for a non phone bill file
    When I request a full report for a non phone bill file
    Then bell should tell me that the path passed is a non phone bill file

  Scenario: Requesting a full report for an invalid phone bill file
    When I request a full report for an invalid phone bill file
    Then bell should tell me that the path passed is an invalid phone bill
