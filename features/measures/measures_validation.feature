
Feature: Validate create measure form fields on save or submit

  Scenario: Tariff manager cannot submit a blank create measure form
    Given I am on the tariff main menu
    When I open a new create measure form
    And I submit an empty form
    Then errors indicating the mandatory fields are displayed

  Scenario: Tariff manager cannot save progress on a blank create measure form
    Given I am on the tariff main menu
    When I open a new create measure form
    And I save progress
    Then errors indicating the mandatory fields are displayed

  @ME2 @ME4 @ME86
  Scenario Outline: Tariff manager cannot submit create measure form when a mandatory field is missing
    Given I am on the tariff main menu
    When I open a new create measure form
    And I enter all mandatory fields except "<field>"
    Then an "<field>" error message is displayed
    Examples:
      |field          |
      |start_date     |
      |workbasket_name|
      |commodity_codes|
      |origin         |
      |regulation     |
      |measure_type   |

  Scenario Outline: Tariff manager can create a measure where start date is past, present or future
    Given I am on the tariff main menu
    When I open a new create measure form
    And I fill the required fields and enter a "<start_date>" date
    Then the measure can be submitted for cross check
    Examples:
      |start_date|
      |past      |
#      |present   |
      |future   |

  @ME25
  Scenario: Measure end date cannot be earlier than the measure's start date
    Given I am on the tariff main menu
    When I open a new create measure form
    And I enter an end date which is earlier than the start date
    Then an "ME25" error message is displayed

  @ME12
  Scenario: Additional code has no relationship with the measure type
    Given I am on the tariff main menu
    When I open a new create measure form
    And I fill in the form for a "me12_additional_code"
    Then an "ME12" error message is displayed

  @ME1
  Scenario: Combination of start date, measure type, geographical area, commodity code must be unique
    Given I am on the tariff main menu
    When I open a new create measure form
    And I fill the required fields and enter a "present" date
    When I go back to the tariff main menu
    And I open a new create measure form
    And I fill the required fields and enter a "present" date
    Then an "ME1" error message is displayed

  @wip
  @feature-not-implemented
  Scenario: Duty expression is mandatory where required by the selected measure type
    Given I am on the tariff main menu
    When I open a new create measure form
    And I do not enter a duty expression when the selected measure type requires one
    Then an "duty_expression" error message is displayed
