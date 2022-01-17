require 'selenium-webdriver'
require "rspec"
require 'rest-client'
require 'json'

url_get = RestClient.get "https://jsonplaceholder.typicode.com/todos", { accept: :json }

Given('user has successfully reach API.') do
  expect(url_get.code).to eq(200)
end

When('user tries a get request.') do
  expect(url_get.body.class.to_s).to eq("String")
end

Then('user should get valid JSON response.') do
  @data = JSON.parse(url_get.body)
  @data.nil?
end

Then('user should get valid JSON key format.') do |table|
  table_array = table.raw.collect { |row| row.flatten }
  @data_response = JSON.parse url_get.body
  @data_response.each { |k|
    expect(k.keys).to match_array(table_array.flatten) }
end

Then('user should get valid JSON value format type.') do |table|
  table_value_array = table.raw.collect { |row| row.flatten }
  @data_response = JSON.parse url_get.body
  @data_response.each { |k|
    #expect(k.values.to_a.length).to eq(table_value_array.flatten.length)
    dummy_arr = []
    count = 0
    k.values.to_a.each { |a_values|
      if count == 4
        expect(dummy_arr).to match_array(table_value_array.flatten)
        count=0
        dummy_arr.clear
      end
      if a_values.class == 'FalseClass' || a_values.class =='TrueClass'
        dummy_arr.append('Boolean')
      else
        dummy_arr.append(a_values.class)
      end
      count+=1
      }
  }
end