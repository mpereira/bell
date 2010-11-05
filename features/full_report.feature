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

  Scenario: Non phone bill file
    Given a file named "non_phone_bill.txt" with:
    """
    Lorem ipsum dolor sit amet, consectetur adipisicing elit
    """
    When I request a full report using "non_phone_bill.txt"
    Then bell should tell me that "non_phone_bill.txt" is an invalid phone bill file


  Scenario: Invalid phone bill file
    Given a file named "invalid.csv" with:
    """
    ,,,,,,,,,,,,,
    ,,,,,,,,,,,,,
    "Seq       ","Origem                                            ","Descri��o                                         ","Periodo/Data             ","Terminal_Destino    ","Local Origem","Local Destino       ","Hora Inicio    ","Hora Fim            ","Imp ","Pais      ","Qtde    ","Unid    ","Valor (R$)          "
    1,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","11/08/10 A  99/99/99     ",1993692887,"SCL -SP   ","CAS -SP             ",02:56:29 AM,"                    ","E   ","          ",500,"MIN     ",0.73
    2,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","11/08/10 A  99/99/99     ",1993692887,"SCL -SP   ","CAS -SP             ",02:59:03 AM,"                    ","E   ","          ",900,"MIN     ",1.3
    3,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  "

    """
    When I request a full report using "invalid.csv"
    Then bell should tell me that "invalid.csv" is an invalid phone bill file

  Scenario: Valid phone bill file
    Given a user with name "bob" exists
    And a user with name "earl" exists
    And "bob" has a contact with number "1993692887" in his contact list
    And "earl" has a contact with number "1992563321" in his contact list
    And a file named "fatura.csv" with:
    """
,,,,,,,,,,,,,
,,,,,,,,,,,,,
"Seq       ","Origem                                            ","Descri��o                                         ","Periodo/Data             ","Terminal_Destino    ","Local Origem","Local Destino       ","Hora Inicio    ","Hora Fim            ","Imp ","Pais      ","Qtde    ","Unid    ","Valor (R$)          "
1,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","11/08/10 A  99/99/99     ",1993692887,"SCL -SP   ","CAS -SP             ",02:56:29 AM,"                    ","E   ","          ",500,"MIN     ",0.73
2,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","11/08/10 A  99/99/99     ",1993692887,"SCL -SP   ","CAS -SP             ",02:59:03 AM,"                    ","E   ","          ",900,"MIN     ",1.3
3,"1634125644-FRANQUIA 01                            ","04 - LIGACOES DDD PARA CELULARES                  ","13/08/10 A  99/99/99     ",1992563321,"SCL -SP   ","CAS -SP             ",09:07:55 PM,"                    ","E   ","          ",5800,"MIN     ",8.47

    """
    When I request a full report using "fatura.csv"
    Then the output should be:
    """

    [resumo]
    Total:                   10.50
    De usuários:             10.50
    Desconhecidas:           0.00

    [usuários]
    bob                      2.03
    earl                     8.47

    [ligações desconhecidas]

    """
