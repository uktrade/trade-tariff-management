Feature: As a Tariff Manager
  I want to log in to the Tariff application main menu


  Scenario: Tariff manager can login and click on the link 'Create new additional codes' link
    Given I am on the tariff main menu
    When I click on the link Create new additional codes
    Then Create new additional codes form is displayed


    Scenario: Tariff manager can enter the workbasket name
      Given I am on the tariff main menu
      When I click on the link Create new additional codes
      And I enter the workbasket name
      And I enter the start date
      And I click on save button
      Then I return to the tariff main menu
      And the workbasket status is "New - in progress"


      Scenario: Tariff manager can create the additional code
        Given I am on the tariff main menu
        When I click on the link Create new additional codes
        And I enter the workbasket name
        And I enter the start date
        And I enter additional code type
        And I enter additional code
        And I enter desciption
        And I click on the submit for cross-check button
        Then I return to the tariff main menu
        And the workbasket status is "Awaiting cross-check"