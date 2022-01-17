require "ToDoMVC/version"

module ToDoMCV
  list_store = []

  def self.check_items (task_check, action)
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

  def self.add_tasks
    $list_of_tasks = ['Pick up grocery', 'Water plants', 'Wash car', 'Laundry']
    to_do_tab = $wait.until { @browser.find_element(class: 'new-todo') }
    $list_of_tasks.each do |tasks|
      to_do_tab.send_keys tasks.to_s
      to_do_tab.send_keys :enter
    end
  end

  def self.edit_items (task_edit)
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

  def self.remove_task (remove_list)
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

end