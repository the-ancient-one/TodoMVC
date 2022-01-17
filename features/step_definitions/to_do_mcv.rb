require 'selenium-webdriver'
require "rspec"

$wait = Selenium::WebDriver::Wait.new(:timeout => 20)
list_store = []

def add_tasks ()
  $list_of_tasks = ['Pick up grocery', 'Water plants', 'Wash car', 'Laundry']
  to_do_tab = $wait.until { @browser.find_element(class: 'new-todo') }
  $list_of_tasks.each do |tasks|
    to_do_tab.send_keys tasks.to_s
    to_do_tab.send_keys :enter
  end
end

def check_items (task_check, action)
  items_list = $list_of_tasks.dup
  list_table = $wait.until { @browser.find_element(class: 'todo-list') }
  task_check.each { |tasks|
    list_table.text.split("\n").each.with_index(1) do |_, index|
      list_table.find_elements(xpath: "/html/body/section/div/section/ul/li[#{index}]/div").each { |cell|
        if list_table.find_element(xpath: "/html/body/section/div/section/ul/li[#{index}]/div/label").text == (tasks)
          list_table.find_element(xpath: "/html/body/section/div/section/ul/li[#{index}]/div/input").click
          if action == 'delete'
            items_list.delete(tasks.to_s)
          elsif action == 'add'
            items_list.clear
            items_list.append(tasks.to_s)
          elsif action == 'same'
          end
        end
      }
    end
  }
  items_list
end

def edit_items (task_edit)
  items_list = $list_of_tasks.dup
  list_table = $wait.until { @browser.find_element(class: 'todo-list') }
  task_edit.each { |tasks, newtasks|
    list_table.text.split("\n").each.with_index(1) do |_, index|
      list_table.find_elements(xpath: "/html/body/section/div/section/ul/li[#{index}]/div").each { |cell|
        if list_table.find_element(xpath: "/html/body/section/div/section/ul/li[#{index}]/div/label").text == (tasks)
          task_to_edit = list_table.find_element(xpath: "/html/body/section/div/section/ul/li[#{index}]/div/label")
          #@browser.action.double_click(task_to_edit).perform
          #@browser.execute_script("arguments[0].setAttribute('class','editing')", task_to_edit)
          edit_text = @browser.find_element(:xpath, "/html/body/section/div/section/ul/li[#{index}]/input")
          @browser.action.move_to(task_to_edit).double_click(task_to_edit).perform
          @browser.action.key_down(:control)
                  .send_keys("a")
                  .key_up(:control)
                  .perform
          edit_text.send_keys :delete
          edit_text.send_keys newtasks.to_s
          edit_text.send_keys :enter
          @browser.save_screenshot('edit.png')
          items_list.map { |x| x == tasks.to_s ? newtasks.to_s : x }
        end
      }
    end
  }
  items_list
end

def remove_task (remove_list)
  items_list = $list_of_tasks.dup
  @browser.find_element(:xpath, '/html/body/section/div/footer/ul/li[1]/a').click
  list_table = $wait.until { @browser.find_element(class: 'todo-list') }
  remove_list.each { |tasks|
    list_table.text.split("\n").each.with_index(1) do |_, index|
      list_table.find_elements(xpath: "/html/body/section/div/section/ul/li[#{index}]/div").each { |cell|
        if list_table.find_element(xpath: "/html/body/section/div/section/ul/li[#{index}]/div/label").text == (tasks)
          text_field = list_table.find_element(xpath: "/html/body/section/div/section/ul/li[#{index}]/div")
          remove_button = list_table.find_element(xpath: "/html/body/section/div/section/ul/li[#{index}]/div/button")
          @browser.action.move_to(text_field).click(remove_button).perform
          items_list.delete(tasks.to_s)
        end
      }
    end
  }
  items_list
end

Given('user has successfully opened app.') do
  @browser.get "https://todomvc.com/examples/react/#/"
  @browser.title #=> 'React • TodoMVC'
end

When('user tries to enter ChecklistTask.') do |table|
  table_array = table.raw.collect { |row| row.flatten }
  table_array.flatten.each { |tasks|
    to_do_tab = $wait.until { @browser.find_element(class: 'new-todo') }
    to_do_tab.send_keys tasks.to_s
    to_do_tab.send_keys :enter
  }
end

Then('user should be able record them.') do
  element = $wait.until { $wait.until { @browser.find_element(class: 'todo-list') } }
  element if element.displayed?
end

When('user marks task as completed.') do |table|
  table_array = table.raw.collect { |row| row.flatten }
  check_items table_array.flatten, 'same'
end

Then('user should be able its green checked.') do
  @browser.save_screenshot('checked_list.png')
end

When('user clicks on Active tasks.') do |table|
  table_array = table.raw.collect { |row| row.flatten }
  add_tasks
  @active_task = check_items table_array, 'delete'
end

Then('user should be able see ActiveTask and see number of items left.') do
  @browser.find_element(:xpath, '/html/body/section/div/footer/ul/li[2]/a').click
  active_task_list = $wait.until { @browser.find_element(class: 'todo-list') }
  expect(@active_task).to eq(active_task_list.text.split("\n"))
  @browser.save_screenshot('checked_list.png')
end

When('user clicks on Completed tasks.') do |table|
  table_array = table.raw.collect { |row| row.flatten }
  add_tasks
  @completed_list = check_items table_array.flatten, 'add'
end

Then('user should be able see  Completed and see number of items left.') do
  @browser.find_element(:xpath, '/html/body/section/div/footer/ul/li[3]/a').click
  completed_task_list = @browser.find_elements(class: 'todo-list').collect { |li|
    li.find_element(class: 'view').text
  }
  expect(@completed_list).to eq(completed_task_list)
  @browser.save_screenshot('checked_list.png')
end

When('user clicks complete on task and Clear completed.') do |table_completed|
  table_array = table_completed.raw.collect { |row| row.flatten }
  add_tasks
  check_items table_array.flatten, 'delete'
  sleep 1
  @browser.find_element(class: 'clear-completed').click
end

Then('CompletedTask should be removed from list.') do
  mark_complete_list = $wait.until { @browser.find_element(class: 'todo-list') }
  expect(['Water plants', 'Wash car', 'Laundry']).to eq(mark_complete_list.text.split("\n"))
end

Then('user should be able see tasks appear in Completed tasks and uncheck.') do |table|
  table_array = table.raw.collect { |row| row.flatten }
  @browser.find_element(:xpath, '/html/body/section/div/footer/ul/li[3]/a').click
  expected_tasks = check_items table_array, 'same'
  @browser.find_element(:xpath, '/html/body/section/div/footer/ul/li[1]/a').click
  current_list_of_tasks = $wait.until { @browser.find_element(class: 'todo-list') }
  expect(expected_tasks).to eq(current_list_of_tasks.text.split("\n"))
  @browser.save_screenshot('checked_list.png')
end

When('user double click and edit task.') do |table|
  table_array = table.raw.collect { |row| row.flatten }
  add_tasks
  @edited_list = edit_items table_array
end

Then('user should be updated.') do
  @browser.find_element(:xpath, '/html/body/section/div/footer/ul/li[1]/a').click
  current_list_of_tasks = $wait.until { @browser.find_element(class: 'todo-list') }
  expect(@edited_list).not_to eq(current_list_of_tasks.text.split("\n"))
end

When('user clicks on Remove tasks.') do |table|
  table_array = table.raw.collect { |row| row.flatten }
  add_tasks
  @remaining_task = remove_task table_array.flatten
end

Then('user should be able see tasks remove from list.') do
  @browser.find_element(:xpath, '/html/body/section/div/footer/ul/li[1]/a').click
  current_list_of_tasks = $wait.until { @browser.find_element(class: 'todo-list') }
  expect(@remaining_task).to eq(current_list_of_tasks.text.split("\n"))
  @browser.save_screenshot('checked_list.png')
end

When('user clicks on Mark all tasks button.') do
  add_tasks
  @browser.find_element(:xpath, '/html/body/section/div/section/label').click
end

Then('user should be able see all tasks checked as completed and zero items left.') do
  completed_list = @browser.find_elements(class: 'completed').collect { |li|
    li.find_element(class: 'view').text
  }
  expect($list_of_tasks).to eq(completed_list)
end