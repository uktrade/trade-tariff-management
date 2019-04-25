
Feature: As a Tariff Manager
  I want to create measures with different parameters

  Background:
    Given I am on the tariff main menu
    When I open a new create measure form

  Scenario Outline: Create measure with goods commodity code
    And I fill in the form for a "<scenario>"
    And I can review the measure
    And I can review the measure for commodity codes
    And the summary lists the measures to be created
    And I can submit the measure for cross check
    Examples:
      |scenario               |
      |single_commodity_code  |
      |multiple_commodity_code|

  Scenario Outline: Create measure with commodity code exceptions
    And I fill in the form for a "<scenario>"
    And I can review the measure
    And I can review the measure for commodity codes
    And I can review the measure for goods exceptions
    And I can submit the measure for cross check
    Examples:
      |scenario                |
      |single_goods_exception  |
      |multiple_goods_exception|
      |multiple_goods_single_exception|

  Scenario Outline: Create measure with additional codes
    And I fill in the form for a "<scenario>"
    And I can review the measure
    And I can review the measure for commodity codes
    And I can review the measure for additional codes
    And the summary lists the additional codes to be created
    And I can submit the measure for cross check
    Examples:
      |scenario                |
      |single_additional_code  |
      |multiple_additional_code|

  Scenario: Create measure with Meursing codes (no commodity code)
    And I fill in the form for a "meursing_code"
    And I can review the measure
    And I can review the measure for meursing codes
    And I can submit the measure for cross check

  Scenario: Create measure with a footnote
    And I fill in the form for a "single_commodity_code"
    And I can review the measure
    And I can review the measure for commodity codes
    And the measure to be created has a footnote
    And I can submit the measure for cross check

  Scenario Outline: Create measure with a condition
    And I fill in the form for a "<conditions>"
    And I can review the measure
    And I can review the measure for commodity codes
    And the measure to be created has a condition
    And I can submit the measure for cross check
    Examples:
      |conditions                   |
      |condition_with_certificate   |
      |condition_with_no_certificate|

  Scenario: Check commodity and additional codes description
    And I check the description of a commodity code
    Then the commodity code description is displayed
    When I check the description of an additional code
    Then the additional code description is displayed

  Scenario Outline: Create measure of various measure types (Commodity codes only)
    And I fill in the form for a "<scenario>"
    And I can review the measure
    And I can review the measure for commodity codes
    And the summary lists the measures to be created
    And I can submit the measure for cross check
    Examples:
      |scenario               |
      |106_customs_union|
      |110_suplemantary_unit|
      |141_preferential_suspension|
      |277_import_prohibition|
      |465_restriction_on_entry_free_circulation|
      |420_entry_free_circulation|
#       420 Needs 3 conditions

  Scenario Outline: Create measure of various measure types (Additional codes only)
    And I fill in the form for a "<scenario>"
    And I can review the measure
    And I can review the measure for additional codes
    And the summary lists the additional codes to be created
    And I can submit the measure for cross check
    Examples:
      |scenario               |
      |551_provisional_anti_dumping_duty|


