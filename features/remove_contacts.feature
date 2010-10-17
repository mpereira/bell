@no-txn
Feature: Shell contact removes a user
  As a person using the shell
  I want to remove contacts
  In order to keep my contact lists updated

  Scenario: Removing a contact for a user that doesn't exist
    Given no contact with name "murilo" exists
    When I remove the contact with name "murilo"
    Then bell should tell me that there is no contact with name "murilo"

  Scenario: Removing a contact for an existing user
    Given a contact with name "murilo" exists
    When I remove the contact with name "murilo"
    Then bell should tell me that the contact "murilo" was removed
