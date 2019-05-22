Feature: Quota validation


  Scenario: Quota cannot have both monetary unit and measurement unit
    Given I am on the tariff main menu
    When I open a new create quota form
    And I fill in the quota form for a "quota_with_monetary_and_measurement_unit"
    Then an "monetary_and_measurement_unit" error message is displayed on the quota form
