Feature: Health check
  Scenario: Check health of the application
    When a client does a GET request to "/health"
    Then the response should be JSON:
      """
      {
        "healthy": true
      }
      """
