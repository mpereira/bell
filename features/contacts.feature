Feature: Manage contacts
  As a person using the shell
  I want to manage contacts
  In order to associate calls from the phone bill to users

  Scenario: Creating contact when it doesn't exist for an existing user
    Given the user named "murilo" exists
    And no contact named "augusto" exists
    When I run bell with "contact create augusto -n 1234567890 -u murilo"
    Then bell should tell me that the contact "augusto" was created
    And the contact "augusto" should belong to "murilo"
