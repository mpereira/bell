@no-txn
Feature: Shell user imports a csv file of public contacts
  As a person using the shell
  I want to import public contacts
  In order to split common phone calls between all users

  Scenario: Valid contacts file
    Given a file named "public_contacts.csv" with:
    """
    "john",1234123412
    "bob",9876987698
    """
    When I request a public contact import using "public_contacts.csv"
    Then "john" should be in the public contact list
    And "bob" should be in the public contact list
    And the output should be:
    """
    'john (1234123412)' adicionado à lista de contatos públicos.
    'bob (9876987698)' adicionado à lista de contatos públicos.
    """
