Feature: Search for a measure


  Scenario: User can find a measure
    Given I am on the tariff main menu
    When I open the Find Measures form
    And I search for a measure
    Then a result is returned