@mvc @ui
Feature: Testing of TodoMVC
  Below cases are to check functionality of the To do web based app.

  #Scenario: Check if user can successfully open of app.

  Scenario: Check if user can add To do checklist.
    Given  user has successfully opened app.
    When user tries to enter ChecklistTask.
      | tasks           |
      | Pick up grocery |
      | Water plants    |
      | Wash car        |
      | Laundry         |
    Then user should be able record them.

  Scenario: Check if user can check items of checklist.
    Given  user has successfully opened app.
    And   user tries to enter ChecklistTask.
      | tasks           |
      | Pick up grocery |
      | Water plants    |
      | Laundry         |
    When user marks task as completed.
      | tasks           |
      | Pick up grocery |
      | Laundry         |
    Then user should be able its green checked.


Scenario: User able to see Active.
    Given  user has successfully opened app.
    When user clicks on Active tasks.
      | tasks    |
      | Wash car |
      | Laundry  |
    Then user should be able see ActiveTask and see number of items left.


  Scenario: Check if user can see Completed tasks.
    Given  user has successfully opened app.
    When user clicks on Completed tasks.
      | tasks        |
      | Water plants |
    Then user should be able see  Completed and see number of items left.


  Scenario: Check if user can Clear completed tasks.
    Given  user has successfully opened app.
    When user clicks complete on task and Clear completed.
      | tasks           |
      | Pick up grocery |
    Then CompletedTask should be removed from list.


  Scenario: Check if user can uncheck Tasks.
    Given  user has successfully opened app.
    When user clicks on Active tasks.
      | tasks        |
      | Water plants |
      | Laundry      |
    Then user should be able see tasks appear in Completed tasks and uncheck.
      | tasks        |
      | Water plants |
      | Laundry      |

  Scenario: Check if user can Edit Tasks.
    Given  user has successfully opened app.
    When user double click and edit task.
      | tasks        | newtasks              |
      | Water plants | Water plants and trim |
    Then user should be updated.

  Scenario: Check if user can remove/delete Active.
    Given  user has successfully opened app.
    When user clicks on Remove tasks.
      | tasks |
      | Wash car   |
    Then user should be able see tasks remove from list.

  Scenario: Check if user can Mark all completed.
    Given  user has successfully opened app.
    When user clicks on Mark all tasks button.
    Then user should be able see all tasks checked as completed and zero items left.