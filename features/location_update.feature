# An example of the usage of cucumber, see https://cucumber.io/ for more details on Cucumber

Feature: Update location
  Scenario: Update lights by sending surrounding mac addresses
    Given the user "jasperste" exists
    When a client does a POST request to "/user/jasperste/encountered_lights" with the following data:
    """json
    {
      "MACs": ["A1-5E-DE-73-CA-C7", "69-DD-3B-20-BB-76"]
    }
    """
    Then the response status should be "201"
    And user "jasperste" should have registered "A1-5E-DE-73-CA-C7"
    And user "jasperste" should have registered "69-DD-3B-20-BB-76"
