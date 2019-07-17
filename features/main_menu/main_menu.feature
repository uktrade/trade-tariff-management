
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

  Scenario: Measure - Tariff Manager can submit work basket for cross-check and then withdraw it.
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
    When I go back to the tariff main menu
    Then the workbasket status is "Editing"

  Scenario: Quota - Tariff Manager can submit work basket for cross-check and then withdraw it.
    Given I am on the tariff main menu
    When I open a new create quota form
    And I fill in the quota form for a "quota_condition_footnote"
    And I can submit the quota for cross check
    When I return to the tariff main menu
    Then the workbasket status is "Awaiting cross-check"
    And the workbasket has next step "View"
    And the workbasket has next step "Withdraw/edit"
    And I can view the workbasket
    When I return to the tariff main menu
    Then I can withdraw the workbasket for the quota
    When I return to the tariff main menu
    Then the workbasket status is "Editing"

  Scenario: Cross check, approve and generate xml for a work basket
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
    And the workbasket has next step "View"
    And the workbasket has next step "Withdraw/edit"
    When I login as a "approver"
    Then the workbasket status is "Awaiting approval"
    And the workbasket has next step "View"
    And the workbasket has next step "Review for approval"
    When I click "Review for approval"
    And I approve the workbasket
    And I return to the tariff main menu
    Then the workbasket status is "Awaiting CDS upload - create new"
    And the workbasket has next step "View"
    When I login as a "tariff_manager"
    Then the workbasket status is "Awaiting CDS upload - create new"
    And the workbasket has next step "View"
    When I click on XML generation
    And I schedule the basket for export
    And I return to the tariff main menu
    Then the workbasket status is "Sent to CDS"
    And the XML is generated

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
    And the workbasket has next step "View"
    And the workbasket has next step "Withdraw/edit"

  Scenario: Approver can reject a work basket
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
    When I login as a "approver"
    Then the workbasket status is "Awaiting approval"
    When I click "Review for approval"
    And I do not approve the workbasket
    When I return to the tariff main menu
    Then the workbasket is no longer displayed
    When I login as a "tariff_manager"
    Then the workbasket status is "Approval rejected"
    And the workbasket has next step "View"
    And the workbasket has next step "Withdraw/edit"

  Scenario: Bulk edit measures - Cross-check rejected workbasket should have the View and Withdraw/edit links
    Given I am on the tariff main menu
    When I click the find and edit measure link
    And I search for multiple measures by measure sid "3647"
    And I select the first available measure to work with
    And I bulk edit the selected measures with action "Change origin"
    Then the measure is updated with the "Change origin" change
    When I submit the bulk edit measure for cross-check
    And I login as a "cross_checker"
    Then the workbasket status is "Awaiting cross-check"
    When I click "Review for cross-check"
    And I can crosscheck and reject the workbasket
    And I login as a "tariff_manager"
    Then the workbasket status is "Cross-check rejected"
    And the workbasket has next step "View"
    And the workbasket has next step "Withdraw/edit"