ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
# TODO silence output
load Rails.root.join "db/schema.rb"
require 'rails/test_help'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...

  def before_setup
    # Reset the DB before each test to make a clean slate.
    # I swear this was easier back in like 2012!
    [ShortCode].each do |model|
      ApplicationRecord.connection.execute("Delete from #{model.table_name}")
      ApplicationRecord.connection.execute("DELETE FROM SQLITE_SEQUENCE WHERE name='#{model.table_name}'")
    end

    super
  end
end
