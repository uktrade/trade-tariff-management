#@wip
Feature: As a Tariff Manager
         I want to create measures with different parameters

  Background:
    Given I am on the tariff main menu
    When I open a new create measure form

  Scenario Outline: Create measure with goods commodity code
    And I fill in the form for a "<scenario>"
    And I can review the measure
    And the summary lists the measures to be created
#    And I submit the measure for crosscheck
#    Then the measure is submitted
    Examples:
      |scenario               |
      |single_commodity_code  |
      |multiple_commodity_code|

  Scenario Outline: Create measure with commodity code exceptions
    And I fill in the form for a "<scenario>"
    And I can review the measure
    And I can review the measure for goods exceptions
#    And I submit the measure for crosscheck
#    Then the measure is submitted
    Examples:
      |scenario                |
      |single_goods_exception  |
      |multiple_goods_exception|

  Scenario Outline: Create measure with additional codes
    And I fill in the form for a "<scenario>"
    And I can review the measure
    And I can review the measure for additional codes
    And the summary lists the additional codes to be created
#    And I submit the measure for crosscheck
#    Then the measure is submitted
    Examples:
      |scenario                |
      |single_additional_code  |
      |multiple_additional_code|

  Scenario: Create measure with Meursing codes (no commodity code)
    And I fill in the form for a "meursing_code"
    And I can review the measure
    And I can review the measure for meursing codes
#    And I submit the measure for crosscheck
#    Then the measure is submitted

  Scenario: Create measure with a footnote
    And I fill in the form for a "single_commodity_code"
    And I can review the measure
    And the measure to be created has a footnote
#    And I submit the measure for crosscheck
#    Then the measure is submitted

  Scenario Outline: Create measure with a condition
    And I fill in the form for a "<conditions>"
    And I can review the measure
    And the measure to be created has a condition
#    And I submit the measure for crosscheck
#    Then the measure is submitted
    Examples:
      |conditions                   |
      |condition_with_certificate   |
      |condition_with_no_certificate|



