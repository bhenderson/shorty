require 'test_helper'

class WelcomeControllerTest < ActionDispatch::IntegrationTest
  def test_welcome
    get root_url

    assert_select "form"
    assert_select ".h3", "Hello Friend"
  end
end
