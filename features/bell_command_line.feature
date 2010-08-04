Feature: Command line interface
  As a person using the shell
  I want to use bell's command line interface
  In order to split a shared phone line bill painlessly

  Scenario: No arguments
    When I run "bell"
    Then the stdout should contain "Comandos"
