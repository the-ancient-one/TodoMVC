Before do
  #service = Selenium::WebDriver::Service.firefox(path: '/usr/local/bin/geckodriver')
  opts = Selenium::WebDriver::Firefox::Options.new(args: ['-headless'])
  @browser = Selenium::WebDriver.for :firefox, options: opts
  # @browser.get "https://todomvc.com/examples/react/#/"
end

After do
  @browser.quit
end
