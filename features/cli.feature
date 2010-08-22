Feature: Command line interface
  As a person using the shell
  I want to interact with bell's command line interface
  In order to split a shared phone line bill painlessly

  Scenario: No arguments
    When I run bell with ""
    Then bell should show the usage

  Scenario: Valid user creation
    Given no user named "murilo" exists
    When I run bell with "user create murilo"
    Then bell should tell that the user "murilo" was created
    And I should have the user "murilo" in the database

  Scenario: User creation attempt when given user already exists
    Given the user named "murilo" exists
    When I run bell with "user create murilo"
    Then bell should tell that the user "murilo" already exists
