@no-txn
Feature: Shell user imports a csv file of contacts
  As a person using the shell
  I want to import contacts
  In order to associate phone calls to users

  Scenario: Non-existing file
    When I request a contact import using "/non/existant/path"
    Then bell should tell me that "/non/existant/path" does not exist

  Scenario: Directory
    Given a directory named "tmp"
    When I request a contact import using "tmp"
    Then bell should tell me that "tmp" is a directory

  Scenario: Invalid contacts file
    Given a file named "invalid.csv" with:
    """
    "john",1234123412
    "bob
    """
    When I request a contact import using "invalid.csv"
    Then bell should tell me that "invalid.csv" is an invalid contacts file

  Scenario: Valid contacts file
    Given a user with name "earl" exists
    And "earl" has an empty contact list
    And a file named "earl.csv" with:
    """
    "john",1234123412
    "bob",9876987698
    """
    When I request a contact import for "earl" using "earl.csv"
    Then the output should be:
    """
    'john (1234123412)' adicionado à lista de contatos do usuário 'earl'.
    'bob (9876987698)' adicionado à lista de contatos do usuário 'earl'.
    """
    And "earl" should have "john" in his contact list
    And "earl" should have "bob" in his contact list