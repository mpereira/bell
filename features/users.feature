Feature: Users
  As a person using the shell
  I want to manage users
  In order to split a shared phone line bill painlessly

  Scenario: User creation attempt when given user doesn't exist
    Given no user named "murilo" exists
    When I run bell with "user create murilo"
    Then bell should tell that the user "murilo" was created
    And I should have the user "murilo" in the database

  Scenario: User creation attempt when given user already exists
    Given the user named "murilo" exists
    When I run bell with "user create murilo"
    Then bell should tell that the user "murilo" already exists

  Scenario: Listing users when no users are in the database
    Given no user exists
    When I run bell with "user list"
    Then the messenger should contain "Não há usuários cadastrados"

  Scenario: Listing users when there is one user in the database
    Given the user named "murilo" exists
    When I run bell with "user list"
    Then the messenger should contain "murilo"

  Scenario: Listing users when there is more than one user in the database
    Given the user named "murilo" exists
    And the user named "augusto" exists
    When I run bell with "user list"
    Then the messenger should contain "murilo"
    And the messenger should contain "augusto"
