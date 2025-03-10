Feature: Test home page: open project

  Scenario: Open existing project should redirect to 'models' page
    Given I clear cache
    And   I visit the '/'
    And   I click on '[data-cy="create-project-button"]'
    And   I set on '[data-cy="create-project-form"] [data-cy="name-input"]' text 'projectName'
    And   I click on '[data-cy="create-project-form"] [data-cy="submit-button"]'

    When I click on '[data-cy="navigation-bar"] [data-cy="home-page-link"]'
    Then I expect current url is '/'
    And  I expect '[data-cy="project-card_projectName"]' exists
    And  I expect '[data-cy="project-card_projectName"] [data-cy="title-container"]' is 'projectName'

    When I click on '[data-cy="project-card_projectName"]'
    Then I expect current url is 'projectName/models'
