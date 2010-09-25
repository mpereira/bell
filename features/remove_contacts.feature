@no-txn
Feature: Shell contact removes a user
  As a person using the shell
  I want to remove contacts
  In order to keep my contact lists updated

  Scenario: Contact removal attempt when given contact name doesn't exist
    Given no contact with name "murilo" exists
    When I remove the contact with name "murilo"
    Then bell should tell me that there is no contact with name "murilo"

  Scenario: Contact removal attempt when given contact exists
    Given a contact with name "murilo" exists
    When I remove the contact with name "murilo"
    Then bell should tell me that the contact "murilo" was removed
