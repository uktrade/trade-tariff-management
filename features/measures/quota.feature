
Feature: As a Tariff Manager
  I want to create quotas

  Background:
    Given I am on the tariff main menu
    When I open a new create quota form

  Scenario: Create quota with condition and footnote
    And I fill in the quota form for a "quota_data"
    Then I can review the quota
    And I can review the quota for commodity codes
    And I can review the quota for conditions
    And  I can review the quota for footnotes
    And the quota summary lists the quota periods to be created
    And I can submit the quota for cross check

  Scenario: Create quota with monetary unit EURO
    And I fill in the quota form for a "quota_monetary_unit"
    Then I can review the quota
    And I can review the quota for commodity codes
    And the quota summary lists the quota periods to be created
    And I can submit the quota for cross check

  Scenario: Check commodity and additional codes description
    And I check the description of a commodity code.
    Then the commodity code description is displayed.
    When I check the description of an additional code.
    Then the additional code description is displayed.