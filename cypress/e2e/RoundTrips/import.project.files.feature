Feature: Test roundtrip of the application : import project files

  Background:
    Given I clear cache
    And   I set viewport size to '1920' px for width and '1080' px for height
    And   I set context field 'modelName' with 'modelTest'
    And   I set context field 'projectName' with 'leto-modelizer-project-test'
    And   I set context field 'repository_url' with 'https://github.com/ditrit/leto-modelizer-project-test'
    And   I visit the '/'

  Scenario: Import project redirect to models page with correct plugin and import project files and folders
    # Import project
    When I click on '[data-cy="import-project-button"]'
    And  I set on '[data-cy="import-project-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="import-project-form"] [data-cy="submit-button"]'
    Then I expect 'positive' toast to appear with text 'Project has been imported 🥳!'
    And  I expect current url is '{{projectName}}/models'

    # Create model
    When I click on '[data-cy="create-model-button"]'
    Then I expect '[data-cy="create-model-form"] [data-cy="plugin-select"]' is 'terrator-plugin'

    When I set on '[data-cy="create-model-form"] [data-cy="name-input"]' text '{{modelName}}'
    And  I click on '[data-cy="create-model-form"] [data-cy="submit-button"]'
    Then I expect 'positive' toast to appear with text 'Model has been created 🥳!'
    And  I expect current url is '{{projectName}}/modelizer/draw\?path=terrator-plugin/{{modelName}}'

    # Check project files and folders are created in Text view
    When I click on '[data-cy="modelizer-switch-button"] [aria-pressed="false"]'
    And  I wait 1 second
    Then I expect current url is '{{projectName}}/modelizer/text\?path=terrator-plugin/{{modelName}}'
    And  I expect '[data-cy="file-explorer"] [data-cy="folder_{{projectName}}"]' is '{{projectName}}'
    And  I expect '[data-cy="file-explorer"] [data-cy="folder_terrator-plugin"]' exists
    And  I expect '[data-cy="file-explorer"] [data-cy="folder_terraform"]' exists
    And  I expect '[data-cy="file-explorer"] [data-cy="file_branch.txt"]' exists
    And  I expect '[data-cy="file-explorer"] [data-cy="file_README.md"]' exists

    When I double click on '[data-cy="file-explorer"] [data-cy="file_README.md"]'
    Then I expect '[data-cy="active-tab"] [data-cy="file_README.md"]' exists
    And  I expect active file content to be equal to 'cypress/resources/project-test/README.md'

    When I double click on '[data-cy="file-explorer"] [data-cy="file_branch.txt"]'
    Then I expect '[data-cy="active-tab"] [data-cy="file_branch.txt"]' exists
    And  I expect active file content to contain 'main'
    And  I expect '[data-cy="file-explorer"] [data-cy="folder_terrator-plugin/{{modelName}}"]' exists

    When I click on '[data-cy="file-explorer"] [data-cy="folder_terraform"]'
    Then I expect '[data-cy="file-explorer"] [data-cy="file_terraform/app.tf"]' exists

    When I double click on '[data-cy="file-explorer"] [data-cy="file_terraform/app.tf"]'
    Then I expect '[data-cy="active-tab"] [data-cy="file_terraform/app.tf"]' exists
    And  I expect active file content to be equal to 'cypress/resources/project-test/app.tf'

    # Check project is displayed in home page
    When I visit the '/'
    Then I expect '[data-cy="project-card_{{projectName}}"]' appear 1 time on screen
    And  I expect '[data-cy="project-card_{{projectName}}"] [data-cy="title-container"]' is '{{projectName}}'
