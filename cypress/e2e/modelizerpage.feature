Feature: Test modelizer page

  Background:
    Given I clear cache
    And I set viewport size to "1536" px for width and "960" px for height
    And I visit the "/"

    When I click on "[data-cy=\"create-empty-project\"]"
    Then I expect current url is "/modelizer/project-[a-f0-9]{8}/model"
    And  I extract "project-[a-f0-9]{8}" from url in field "projectName" of context

  Scenario: Default modelizer page mode should be "model"
    When I visit the "/"
    And  I visit the "/#/modelizer/{{projectName}}"
    Then I expect current url is "/modelizer/{{projectName}}/model"

  Scenario: Modelizer "model" page should load the correct content
    Then I expect "[data-cy=\"modelizer-switch\"] [aria-pressed=\"true\"] [class=\"block\"]" is "Model"
    And  I expect "[data-cy=\"modelizer-model-view-draw-root\"]" exists

  Scenario: Modelizer "text" page should load the correct content
    When I visit the "/#/modelizer/{{projectName}}/text"
    Then I expect "[data-cy=\"modelizer-switch\"] [aria-pressed=\"true\"] [class=\"block\"]" is "Text"
    And  I expect "[data-cy=\"modelizer-text-view\"]" exists
    And  I expect "[data-cy=\"file-explorer\"]" exists
    And  I expect "[data-cy=\"file-tabs\"]" exists

  Scenario: Clicking on switch should change page content
    When I click on "[data-cy=\"modelizer-switch\"] [aria-pressed=\"false\"]"
    Then I expect "[data-cy=\"modelizer-switch\"] [aria-pressed=\"true\"] [class=\"block\"]" is "Text"
    And  I expect "[data-cy=\"modelizer-text-view\"]" exists
    And  I expect "[data-cy=\"file-explorer\"]" exists
    And  I expect "[data-cy=\"file-tabs\"]" exists
    And  I expect current url is "/{{projectName}}/text"

    When I click on "[data-cy=\"modelizer-switch\"] [aria-pressed=\"false\"]"
    And  I expect "[data-cy=\"modelizer-model-view-draw-root\"]" exists
    And  I expect current url is "/{{projectName}}/model"

  Scenario: Clicking on application logo should redirect to homepage
    When I click on "[data-cy=\"app-logo-link\"]"
    Then I expect current url is "/"

  Scenario: The modelizer page should have the components definitions drawer
    Then I expect '[data-cy="components-definitions-drawer"]' exists