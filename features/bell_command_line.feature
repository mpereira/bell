Feature: Bell command line interface
  As a regular user
  I want to use bell's command line interface
  In order to split a shared phone line bill painlessly

  Scenario: No arguments
    Given a working directory
    When I run "bell"
    Then the stdout should contain "Comandos"
