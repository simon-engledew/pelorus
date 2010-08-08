Feature: Navigate Map
  In order to see the change initiative
  As a stakeholder
  I want to browse map nodes
  
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
  
#  Scenario: Maps List
#    Given I have maps named "Call Centre Redesign, Office Consolidation"
#    When I go to the list of maps
#    Then I should see "Call Centre Redesign"
#    And I should see "Office Consolidation"
#  
#  Scenario: Goals List
#    Given I have a map named "Call Centre Redesign"
#    And I have goals named "Business Benefits, All Staff Relocated" in the map "Call Centre Redesign"
#    When I go to the list of maps
#    And I follow "Call Centre Redesign"
#    Then I should see "Business Benefits"
#    And I should see "All Staff Relocated"
#  
#  Scenario: Subgoals List
#    Given I have a map named "Call Centre Redesign"
#    And I have a goal named "Business Benefits" in the map "Call Centre Redesign"
#    And I have a goal named "Increased Cross Selling" in the goal "Business Benefits"
#    When I go to the list of maps
#    And I follow "Call Centre Redesign"
#    And I follow "Business Benefits"
#    Then I should see "Increased Cross Selling"
#    When I follow "Increased Cross Selling"
#    Then I should see "<Goal> Increased Cross Selling"
#
#  Scenario: Factors
#    Given I have fixtures
#    When I go to the list of maps
#    And I follow "Call Centre Redesign"
#    And I follow "Business Benefits"
#    Then I should see "Goal achievement date"
#    When I follow "Goal achievement date"
#    Then I should see "<Factor> Goal achievement date"
#  
#  Scenario: Risks
#    Given I have fixtures
#    When I go to the list of maps
#    And I follow "Call Centre Redesign"
#    And I follow "Business Benefits"
#    Then I should see "Cross sales might not materialize"
#    When I follow "Cross sales might not materialize"
#    Then I should see "<Risk> Cross sales might not materialize"