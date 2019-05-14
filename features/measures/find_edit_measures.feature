@ola
Feature: Find and Edit Measures

  Scenario: Find measures and display search result
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for a measure by measure sid
    Then each row has a checkbox which is "checked"
    And the work_with_selected_measure button is "enabled"
    When I deselect all measures
    Then the work_with_selected_measure button is "disabled"
    And each row has a checkbox which is "unchecked"

  Scenario: Measures that are part of a quota should not appear in ‘Find Measures’ search results
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I enter a quota type in the measure type field
    Then there is no option displayed for the quota type

#    @ola
  Scenario Outline: Edit a single measure
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for a measure by measure sid
    And I progress with bulk edit
    And I bulk edit the "<bulk_action>"
    And the measure is updated with the "<bulk_action>" change
    When I return to the tariff main menu
    And I click "Delete"
    Then I can delete the workbasket
    Examples:
      |bulk_action|
      |regulation|
      |duties|
      |commodity code|
      |origin|
      |additional code|
      |validity period|
      |footnote|
#       |condition|

#  @ola
  Scenario Outline: Bulk edit measures
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for multiple measures by measure sid
    And I progress with bulk edit
    And I bulk edit the "<bulk_action>"
    And the measure is updated with the "<bulk_action>" change
    When I return to the tariff main menu
    And I click "Delete"
    Then I can delete the workbasket
    Examples:
      |bulk_action|
      |regulation|
      |duties|
      |commodity code|
      |origin|
      |additional code|
      |validity period|
      |footnote|
#      |condition|
