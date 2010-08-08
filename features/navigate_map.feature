Feature: Navigate Map
  In order to see the change initiative
  As a stakeholder
  I want to browse map nodes
  
  Scenario: Activate Account
    Given I have signed up with the name "Cucumber" and the password "cucumber"
    Then I should receive an email
    When I open the email
    Then I should see "Confirmation instructions" in the email subject
    When I click the first link in the email
    Then I should see "Cucumber (Logout)"
  
  Scenario: Create Map
    Given I am logged in as an admin
    When I follow "new map" within "#maps"
    Then I should see the title "New Map"
    When I fill in the following:
      | name            | Cucumber Map              |
      | description     | Cucumber Map Description  |
    And I select "Cucumber" from "manager"
    When I press "Create"
    Then I should see "<Map> Cucumber Map"
  
  Scenario: Create Goal
    Given I am logged in as an admin
    And I have a map named "Cucumber Map"
    When I go to the list of maps
    And I follow "Cucumber Map"
    When I follow "new goal" within "#goals"
    Then I should see the title "New Goal"
    When I fill in the following:
      | name            | Cucumber Goal               |
      | description     | Cucumber Goal Description   |
    When I press "Create"
    Then I should see "<Goal> Cucumber Goal"
  
  Scenario: Explore Map
    Given I have fixtures
    When I go to the list of maps
    Then I should see "Call Centre Redesign" within "#maps"
    
    When I follow "Call Centre Redesign" within "#maps"
    Then I should see the breadcrumbs "<Map> Call Centre Redesign"
    And I should see "Business Benefits" within "#goals"
    
    When I follow "Business Benefits" within "#goals"
    Then I should see the Goal "Business Benefits"
    And I should see the breadcrumbs "<Map> Call Centre Redesign, <Goal> Business Benefits"
    And I should see "Increased Cross Sales" within "#sub_goals"
    
    When I follow "Increased Cross Sales" within "#sub_goals"
    Then I should see the Goal "Increased Cross Sales"
    And I should see "The annual value of cross sales is greater than that achieved with the old Enquiry process." within "#description"
    And I should see the breadcrumbs "<Map> Call Centre Redesign, <Goal> Business Benefits, <Goal> Increased Cross Sales"
    
    When I follow the breadcrumb "<Map> Call Centre Redesign"
    And I follow "Call Centre Staff Trained" within "#goals"
    And I follow "Number of staff trained" within "#factors"
    Then I should see the Factor "Number of staff trained"
    And I should see the breadcrumbs "<Map> Call Centre Redesign, <Goal> Call Centre Staff Trained, <Factor> Number of staff trained"
    
    When I follow the breadcrumb "<Map> Call Centre Redesign"
    And I follow "Business Benefits" within "#goals"
    And I follow "Cross sales might not materialize" within "#risks"
    Then I should see the Risk "Cross sales might not materialize"
    And I should see the breadcrumbs "<Map> Call Centre Redesign, <Goal> Business Benefits, <Risk> Cross sales might not materialize"
    
    When I follow the breadcrumb "<Goal> Business Benefits"
    Then I should see "Customer Enquiry Process Redesigned" within "#supporting_goals"
    
    When I follow the link element "fieldset#network_view > a"
    Then I should see the element "img#network_view"
    
    When I go to the list of stakeholders
    Then I should see "Simon Engledew (admin)" within "#users"
    And I should see "Wendy Smart" within "#users"
