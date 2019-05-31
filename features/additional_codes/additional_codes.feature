Feature: Create new additional codes


  Scenario: Tariff Manager can create new additional codes
    Given I am on the tariff main menu
    When I open a new additional code form
    And I fill the additional codes form for "multiple_additional_codes"
    Then I can submit the additional code for cross-check
    When I return to the tariff main menu
    Then the workbasket status is "Awaiting cross-check"
    And the workbasket has next step "View"
    And the workbasket has next step "Withdraw/edit"
