
Feature: As a Tariff Manager
  I want to create quotas

  Background:
    Given I am on the tariff main menu
    When I open a new create quota form

  Scenario Outline: Create quota with condition and footnote
    And I fill in the quota form for a "<quota>"
    Then I can review the quota
    And I can review the quota for commodity codes
    And I can review the quota for conditions
    And  I can review the quota for footnotes
    And the quota summary lists the quota periods to be created
    And the quota summary lists the measures to be created
    And I can submit the quota for cross check
    Examples:
      |quota|
      |quota_condition_footnote|
      |custom_quota_with_condition_and_footnote|

  Scenario: Create quota with additional codes only
    And I fill in the quota form for a "quota_additional_codes_only"
    Then I can review the quota
    And I can review the quota for additional codes
    And the quota summary lists the quota periods to be created
    And the quota summary lists the additional codes for measures to be created
    And I can submit the quota for cross check

  Scenario: Create quota with commodity code and additional codes
    And I fill in the quota form for a "quota_commodity_and_additional_codes"
    Then I can review the quota
    And I can review the quota for commodity codes
    And I can review the quota for additional codes
    And the quota summary lists the quota periods to be created
    And the quota summary lists the additional codes for measures to be created
    And I can submit the quota for cross check

  Scenario Outline: Create quota of various types
    And I fill in the quota form for a "<quota>"
    Then I can review the quota
    And I can review the quota for commodity codes
    And the quota summary lists the quota periods to be created
    And the quota summary lists the measures to be created
    And I can submit the quota for cross check
    Examples:
      |quota|
      |annual_quota_without_licence|
      |annual_quota_with_licence|
      |annual_quota_with_multiple_commodity_codes_and_licence|
      |biannual_quota_with_licence|
      |quarterly_quota_with_good_exception_no_licence|
      |monthly_quota_with_multiple_commodity_codes|

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

  Scenario: Quota in a workbasket should be locked
    And I fill in the quota form for a "quota_condition_footnote"
    And I can submit the quota for cross check
    When I return to the tariff main menu
    And I click the find and edit quota link
    And I search for the quota
    Then the quota should be locked in the search result