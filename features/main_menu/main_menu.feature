@ola
Feature: As a Tariff Manager
  I want to log in to the Tariff application main menu


  Scenario: Tariff manager can login and logout of the application
    Given I am on the tariff main menu
    Then the main menu links are displayed
    And I can logout of the application

  Scenario: Tariff Manager can save a work basket
    Given I am on the tariff main menu
    When I open a new create measure form
    And I fill in the form for a "single_commodity_code"
    When I go back to the tariff main menu
    Then the workbasket status is "New - in progress"
    And the workbasket has next step "Continue"
    And the workbasket has next step "Delete"
    When I click "Continue"
    Then I can review the measure
    When I go back to the tariff main menu
    And I click "Delete"
    Then I can delete the workbasket

  Scenario: Tariff Manager can submit work basket for cross-check and then withdraw it.
    Given I am on the tariff main menu
    When I open a new create measure form
    And I fill in the form for a "single_commodity_code"
    Then I can submit the measure for cross check
    When I return to the tariff main menu
    Then the workbasket status is "Awaiting cross-check"
    And the workbasket has next step "View"
    And the workbasket has next step "Withdraw/edit"
    And I can view the workbasket
    When I return to the tariff main menu
    Then I can withdraw the workbasket

  Scenario: Cross Checker can accept a work basket
    Given I am on the tariff main menu
    When I open a new create measure form
    And I fill in the form for a "single_commodity_code"
    Then I can submit the measure for cross check
    When I login as a "cross_checker"
    Then the workbasket status is "Awaiting cross-check"
    And the workbasket has next step "View"
    And the workbasket has next step "Review for cross-check"
    And I can view the workbasket
    When I return to the tariff main menu
    And I click "Review for cross-check"
    Then I can crosscheck and accept the workbasket
    When I return to the tariff main menu
    Then the workbasket is no longer displayed
    When I login as a "tariff_manager"
    Then the workbasket status is "Awaiting approval"
#    Do approval here

  Scenario: Cross Checker can reject a work basket
    Given I am on the tariff main menu
    When I open a new create measure form
    And I fill in the form for a "single_commodity_code"
    Then I can submit the measure for cross check
    When I login as a "cross_checker"
    Then the workbasket status is "Awaiting cross-check"
    When I click "Review for cross-check"
    Then I can crosscheck and reject the workbasket
    When I return to the tariff main menu
    Then the workbasket is no longer displayed
    When I login as a "tariff_manager"
    Then the workbasket status is "Cross-check rejected"

  Scenario: Approver  - Approval accepted

  Scenario: Approver  - Approval rejected

  Scenario: Approver  - Awaiting CDS uplaod
