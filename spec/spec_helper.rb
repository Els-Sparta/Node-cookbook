# frozen_string_literal: true
require 'chefspec'
require 'chefspec/berkshelf'

# Prints out the name of each test
RSpec.configure do |config|
  config.formatter = :documentation
end


# checks how much of the code has been tested
at_exit { ChefSpec::Coverage.report! }
