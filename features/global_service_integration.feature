Feature: Global service integration
  In order to DRY out our resources and make them easier and cheaper to maintain
  As a lp web monkey
  I want to be able to serve the global header and footer from waldorf
  
  Scenario: it should serve the global header on the correct endpoint with the right contents
    Given I go to "/global-head"
    Then the global header should have the correct structure
    And the global header should have the correct content

  Scenario: it should serve the correct global header for a site-section 
    Given I go to "/global-body-header"
    Then the global header for a site section should have the correct structure
  
  Scenario: it should serve the correct global footer
    Given I go to "/global-body-footer"
    Then the global footer should have the correct content
