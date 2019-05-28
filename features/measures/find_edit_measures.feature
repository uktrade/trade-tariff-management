
Feature: Find and Edit Measures

  Scenario: Find measures and display search result
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for a measure by measure sid "3647071"
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

  Scenario Outline: Edit a single measure
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for a measure by measure sid "3647071"
    And I select measures to work with
    And I bulk edit the selected measures with action "<bulk_action>"
    And the measure is updated with the "<bulk_action>" change
    When I return to the tariff main menu
    And I click "Delete"
    Then I can delete the workbasket
    Examples:
      |bulk_action|
      |Change generating regulation|
      |Change duties|
      |Change commodity codes|
      |Change origin|
      |Change additional code|
      |Change validity period|
      |Change footnotes|

  Scenario Outline: Bulk edit measures
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for multiple measures by measure sid "364601"
    And I select measures to work with
    And I bulk edit the selected measures with action "<bulk_action>"
    And the measure is updated with the "<bulk_action>" change
    When I return to the tariff main menu
    And I click "Delete"
    Then I can delete the workbasket
    Examples:
      |bulk_action|
      |Change generating regulation|
      |Change duties|
      |Change commodity codes|
      |Change origin|
      |Change additional code|
      |Change validity period|
      |Change conditions|
      |Change footnotes|

  @manual
#  Comment out the @manual tag above to run this test.
  Scenario: Historical measures should not be deleted after withdrawing a bulk-edit workbasket sent for cross-check
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for multiple measures by measure sid "3647"
    And I select the first available measure to work with
    And I bulk edit the selected measures with action "Change origin"
    Then the measure is updated with the "Change origin" change
    When I submit the bulk edit measure for cross-check
    When I return to the tariff main menu
    When I click the find and edit measure link
    And I search for multiple measures by measure sid "3647"
    Then the search results are displayed
    And I search for the measure by workbasket
    Then there is "1" measure in the search result
    When I return to the tariff main menu
    Then I can withdraw the workbasket
    When I return to the tariff main menu
    And I click the find and edit measure link
    And I search for multiple measures by measure sid "3647"
    Then the search returns the same number of measures
    When I search for the measure by workbasket
    Then there is "0" measure in the search result


  @manual
#  Comment out the @manual tag above to run this test.
  Scenario: Additional measures should not be created after rejecting (cross-check) and withdrawing a bulk-edit workbasket
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for multiple measures by measure sid "3647"
    And I select the first available measure to work with
    And I bulk edit the selected measures with action "Change origin"
    Then the measure is updated with the "Change origin" change
    When I submit the bulk edit measure for cross-check
    When I return to the tariff main menu
    When I click the find and edit measure link
    And I search for multiple measures by measure sid "3647"
    Then the search results are displayed
    And I search for the measure by workbasket
    Then there is "1" measure in the search result
    When I login as a "cross_checker"
    When I click "Review for cross-check"
    Then I can crosscheck and reject the workbasket
    And I login as a "tariff_manager"
    And I can withdraw the workbasket
    When I return to the tariff main menu
    And I continue with submission for cross-check
    When I return to the tariff main menu
    When I login as a "cross_checker"
    And I click "Review for cross-check"
    Then I can crosscheck and accept the workbasket
    When I return to the tariff main menu
    And I click the find and edit measure link
    And I search for multiple measures by measure sid "3647"
    Then the search returns the same number of measures
    When I search for the measure by workbasket
    Then there is "1" measure in the search result


