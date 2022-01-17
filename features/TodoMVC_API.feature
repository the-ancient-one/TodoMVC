@mvc @api
Feature: Testing of TodoMVC API from jsonplaceholder
  Below cases are to check functionality of the To do web based REST API.

  #Scenario: Check if user can successfully open of app.

  Scenario: Check if user can access API website.
    Given  user has successfully reach API.
    When user tries a get request.
    Then user should get valid JSON response.


  Scenario: Check if JSON is in valid format .
    Given  user has successfully reach API.
    When user tries a get request.
    Then user should get valid JSON key format.
      | userId | id | title | completed |

  Scenario: Check if JSON is in valid format .
    Given  user has successfully reach API.
    When user tries a get request.
    Then user should get valid JSON value format type.
      | Integer | Integer | String | Boolean |
