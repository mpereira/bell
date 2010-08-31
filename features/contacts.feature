Feature: Manage contacts
  As a person using the shell
  I want to manage contacts
  In order to associate calls from the phone bill to users

  Scenario: Creating contact for a non-existing user
    Given no user named "murilo" exists
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell that the user "murilo" doesn't exist

  Scenario: Creating contact when it already exists for an existing user
    Given the user named "murilo" exists
    And "murilo" has "augusto" in his contacts
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell me that "murilo" already has "augusto" in his contacts

  Scenario: Creating contact when it doesn't exist for an existing user
    Given the user named "murilo" exists
    And "murilo" doesn't have "augusto" in his contacts
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell me that the contact "augusto" was created for "murilo"
    And "murilo" should have the contact "augusto" in his database

  Scenario: Creating contact for a user when it already exists for another user
    Given the user named "murilo" exists
    And the user named "roberto" exists
    And "roberto" has "augusto" in his contacts
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell me that the contact "augusto" was created for "murilo"
    And "murilo" should have the contact "augusto" in his database
