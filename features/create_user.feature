Feature: Create user
  As a person using the shell
  I want to use bell's command line interface
  In order to split a shared phone line bill painlessly

  Scenario: No arguments
    Given no user named "murilo" exists
    When I run "bell create user murilo"
    Then the stdout should contain "Usuário 'murilo' criado"
    And I should have the file "murilo.yml" on the database
