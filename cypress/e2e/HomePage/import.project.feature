Feature: Test home page: project import

  Background:
    Given I clear cache
    And   I set viewport size to '1920' px for width and '1080' px for height
    And   I set context field 'modelName' with 'modelTest'
    And   I set context field 'projectName' with 'leto-modelizer-project-test'
    And   I set context field 'repository_url' with 'https://github.com/ditrit/leto-modelizer-project-test'
    And   I visit the '/'

  Scenario: Import project should redirect to models page and send positive toast
    When I click on '[data-cy="import-project-button"]'
    And  I set on '[data-cy="import-project-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="import-project-form"] [data-cy="submit-button"]'
    Then I expect 'positive' toast to appear with text 'Project has been imported 🥳!'
    And  I expect current url is '{{projectName}}/models'

  Scenario: Import project should add the project in Home page
    When I click on '[data-cy="import-project-button"]'
    And  I set on '[data-cy="import-project-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="import-project-form"] [data-cy="submit-button"]'
    Then I expect current url is '{{projectName}}/models'

    When I visit the '/'
    Then I expect '[data-cy="project-card_{{projectName}}"]' appear 1 time on screen
    And  I expect '[data-cy="project-card_{{projectName}}"] [data-cy="title-container"]' is '{{projectName}}'

  Scenario: Import project with empty repository should display an error
    When I click on '[data-cy="import-project-button"]'
    And  I click on '[data-cy="import-project-form"] [data-cy="submit-button"]'
    Then I expect '[data-cy="import-project-form"] [role="alert"]' is 'Please type something'

  Scenario: Import project with non valid repository should display an error
    When I click on '[data-cy="import-project-button"]'
    And  I set on '[data-cy="import-project-form"] [data-cy="repository-input"]' text 'invalidUrl'
    And  I click on '[data-cy="import-project-form"] [data-cy="submit-button"]'
    Then I expect '[data-cy="import-project-form"] [role="alert"]' is 'Invalid repository url'

  Scenario: Import project with non existant repository should display an error
    When I click on '[data-cy="import-project-button"]'
    And  I set on '[data-cy="import-project-form"] [data-cy="repository-input"]' text 'https://github.com/ditrit/inexistant'
    And  I click on '[data-cy="import-project-form"] [data-cy="submit-button"]'
    Then I expect 'warning' toast to appear with text 'Can\'t access the repository.'

  Scenario: Import project with same repository url should not duplicate the project
    # Import project
    When I click on '[data-cy="import-project-button"]'
    And  I set on '[data-cy="import-project-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="import-project-form"] [data-cy="submit-button"]'
    Then I expect 'positive' toast to appear with text 'Project has been imported 🥳!'

    When I visit the '/'
    Then I expect '[data-cy="project-card_{{projectName}}"]' appear 1 time on screen
    And  I expect '[data-cy="project-card_{{projectName}}"] [data-cy="title-container"]' is '{{projectName}}'

    # Import another project with same repository url
    When I click on '[data-cy="import-project-button"]'
    And  I set on '[data-cy="import-project-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="import-project-form"] [data-cy="submit-button"]'
    Then I expect 'positive' toast to appear with text 'Project has been imported 🥳!'

    # Check the imported project is only displayed once
    When I visit the '/'
    Then I expect '[data-cy="project-card_{{projectName}}"]' appear 1 time on screen
    And  I expect '[data-cy="project-card_{{projectName}}"] [data-cy="title-container"]' is '{{projectName}}'

  Scenario: Import project with a template should redirect to models page and send positive toast
    Then I expect '[data-cy="template-card_project_template"]' exists
    
    When I click on '[data-cy="template-card_project_template"]'
    Then I expect checkbox '[data-cy="create-project-template-form"] [data-cy="import-project-checkbox"]' is not checked

    When I click on '[data-cy="create-project-template-form"] [data-cy="import-project-checkbox"]'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="name-input"]' text '{{projectName}}'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="submit-button"]'
    Then I expect 'positive' toast to appear with text 'Project has been created 🥳!'
    And  I expect current url is '{{projectName}}/models'

  Scenario: Import project with a template should add the project in Home page
    Then I expect '[data-cy="template-card_project_template"]' exists

    When I click on '[data-cy="template-card_project_template"]'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="import-project-checkbox"]'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="name-input"]' text '{{projectName}}'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="submit-button"]'
    Then I expect current url is '{{projectName}}/models'

    When I visit the '/'
    Then I expect '[data-cy="project-card_{{projectName}}"]' appear 1 time on screen
    And  I expect '[data-cy="project-card_{{projectName}}"] [data-cy="title-container"]' is '{{projectName}}'

  Scenario: Import project with a template with an already existing project name should display an error
    Then I expect '[data-cy="template-card_project_template"]' exists

    # Import project with a template
    When I click on '[data-cy="template-card_project_template"]'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="import-project-checkbox"]'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="name-input"]' text '{{projectName}}'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="submit-button"]'
    Then I expect current url is '{{projectName}}/models'

    # Import another project with the same name
    When I visit the '/'
    And  I click on '[data-cy="template-card_project_template"]'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="import-project-checkbox"]'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="name-input"]' text '{{projectName}}'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="repository-input"]' text '{{ repository_url }}'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="submit-button"]'
    Then I expect '[data-cy="create-project-template-form"] [role="alert"]' is 'Project name already exists.'

  Scenario: Import project with a template with empty repository should display an error
    Then I expect '[data-cy="template-card_project_template"]' exists

    When I click on '[data-cy="template-card_project_template"]'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="import-project-checkbox"]'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="name-input"]' text '{{projectName}}'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="submit-button"]'
    Then I expect '[data-cy="create-project-template-form"] [role="alert"]' is 'Please type something'
    
  Scenario: Import project with a template with non valid repository should display an error
    Then I expect '[data-cy="template-card_project_template"]' exists

    When I click on '[data-cy="template-card_project_template"]'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="import-project-checkbox"]'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="name-input"]' text '{{projectName}}'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="repository-input"]' text 'invalidUrl'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="submit-button"]'
    Then I expect '[data-cy="create-project-template-form"] [role="alert"]' is 'Invalid repository url'
  
  Scenario: Import project with a template with non existant repository should display an error
    Then I expect '[data-cy="template-card_project_template"]' exists

    When I click on '[data-cy="template-card_project_template"]'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="import-project-checkbox"]'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="name-input"]' text '{{projectName}}'
    And  I set on '[data-cy="create-project-template-form"] [data-cy="repository-input"]' text 'https://github.com/ditrit/inexistant'
    And  I click on '[data-cy="create-project-template-form"] [data-cy="submit-button"]'
    Then I expect 'warning' toast to appear with text 'Can\'t access the repository.'
