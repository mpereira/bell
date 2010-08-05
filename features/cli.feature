Feature: Command line interface
  As a person using the shell
  I want to interact with bell's command line interface
  In order to learn how to use it

  Scenario: No arguments
    When I run "bell"
    Then the stdout should contain "Comandos"
