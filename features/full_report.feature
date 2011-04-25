@no-txn
Feature: Shell user requests a full report
  As a person using the shell
  I want to show full reports
  In order to see how much each user spent on phone calls

  Scenario: Non-existing file
    When I request a full report using "/non/existent/path"
    Then bell should tell me that "/non/existent/path" does not exist

  Scenario: Directory
    Given a directory named "tmp"
    When I request a full report using "tmp"
    Then bell should tell me that "tmp" is a directory

  Scenario: Non CSV file
    Given a file named "non_csv_file.txt" with:
    """
    Lorem ipsum dolor sit amet, consectetur adipisicing elit
    """
    When I request a full report using "non_csv_file.txt"
    Then bell should tell me that "non_csv_file.txt" is not a csv file

  Scenario: Malformed CSV file
    Given a file named "malformed_csv_file.csv" with:
    """
    "1", 'first"
    """
    When I request a full report using "malformed_csv_file.csv"
    Then bell should tell me that "malformed_csv_file.csv" is a malformed csv file

  Scenario: Phone bill file with invalid rows
    Given a file named "invalid_rows.csv" with:
    """
    Detalhes da fatura

    "Seq       ","Origem                                            ","Descri��o                                         ","Periodo/Data             ","Terminal_Destino    ","Local Origem","Local Destino       ","Hora Inicio    ","Hora Fim            ","Imp ","Pais      ","Qtde    ","Unid    ","Valor (R$)          "
    1,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","11/08/10 A  99/99/99     ",1993692887,"SCL -SP   ","CAS -SP             ",02:56:29 AM,"                    ","E   ","          ",500
    2,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","11/08/10 A  99/99/99     ",1993692887,"SCL -SP   ","CAS -SP             ",02:59:03 AM,"                    ","E   ","          ",900,"MIN     ",1.3
    3,"1634125644-FRANQUIA 01                            ",

    """
    When I request a full report using "invalid_rows.csv"
    Then bell should tell me that "invalid_rows.csv" has errors on lines 4, 6

  Scenario: Valid phone bill file
    Given a user with name "bob" exists
    And a user with name "earl" exists
    And "bob" has a contact with number "1993692887" in his contact list
    And "earl" has a contact with number "1992563321" in his contact list
    And a public contact with number "1634124321" and name "wig"
    And a file named "fatura.csv" with:
    """
    Detalhes da fatura

    "Seq       ","Origem                                            ","Descri��o                                         ","Periodo/Data             ","Terminal_Destino    ","Local Origem","Local Destino       ","Hora Inicio    ","Hora Fim            ","Imp ","Pais      ","Qtde    ","Unid    ","Valor (R$)          "
    1,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","11/08/10 A  99/99/99     ",1993692887,"SCL -SP   ","CAS -SP             ",02:56:29 AM,"                    ","E   ","          ",500,"MIN     ",0.73
    2,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","11/08/10 A  99/99/99     ",1993692887,"SCL -SP   ","CAS -SP             ",02:59:03 AM,"                    ","E   ","          ",900,"MIN     ",1.3
    3,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","13/08/10 A  99/99/99     ",1992563321,"SCL -SP   ","CAS -SP             ",09:07:55 PM,"                    ","E   ","          ",5800,"MIN     ",8.47
    3,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","13/08/10 A  99/99/99     ",1634124321,"SCL -SP   ","CAS -SP             ",09:07:55 PM,"                    ","E   ","          ",5800,"MIN     ",18.47
    3,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","13/08/10 A  99/99/99     ",1912341234,"SCL -SP   ","CAS -SP             ",09:07:55 PM,"                    ","E   ","          ",5800,"MIN     ",3.70
    3,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","13/08/10 A  99/99/99     ",,"SCL -SP   ","CAS -SP             ",09:07:55 PM,"                    ","E   ","          ",5800,"MIN     ",1.11

    """
    When I request a full report using "fatura.csv"
    Then the output should be:
    """
    [resumo]
    Total:                   33.78
    Usuários:                10.50
    Públicas:                18.47
    Desconhecidas:           3.70
    Taxas:                   1.11

    [usuários]
    bob                      4.44
    earl                     10.88

    [ligações públicas]
    wig (1634124321)         18.47

    [ligações desconhecidas]
    1912341234               3.70
    """
