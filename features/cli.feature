Feature: Command line interface
  As a person using the shell
  I want to interact with bell's command line interface
  In order to split a shared phone line bill painlessly

  Scenario: No arguments
    When I run "bell"
    Then the stdout should contain "Comandos"

  Scenario: Valid user creation
    Given no user named "murilo" exists
    When I run "bell user create murilo"
    Then the stdout should contain "Usuário 'murilo' criado"
    And I should have the user "murilo" in the database
