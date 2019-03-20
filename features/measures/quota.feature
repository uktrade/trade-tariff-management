#@wip
Feature: As a Tariff Manager
  I want to create quotas


  Scenario: Create measure with goods commodity code
    Given I am on the tariff main menu
    When I open a new create quota form
    And I fill in the quota form for a "quota_data"
    Then I can review the quota
    And I can review the quota for commodity codes
    And I can review the quota for conditions
    And  I can review the quota for footnotes
    And the quota summary lists the quota periods to be created
#    When I submit the quota for crosscheck
#    Then the quota is submitted