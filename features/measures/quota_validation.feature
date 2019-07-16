Feature: Testing field validation on the quota form


  Scenario: Mandatory fields cannot be left blank
    Given I am on the tariff main menu
    When I open a new quota form and submit with blank fields
    Then a message is displayed