require 'test_helper'

class ShortCodesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @code = "60d6bea"
    @url = "http://example"
  end

  def test_create
    assert_difference('ShortCode.count') do
      post short_codes_url, params: { short_code: { url: @url} }
    end
    assert_redirected_to root_url(code: @code)
    assert_equal "Congradulations! You've shortened a url!", flash[:notice]
    assert_equal @url, ShortCode.find_by(code: @code).url
  end

  def test_create_invalid_url
    assert_no_difference('ShortCode.count') do
      post short_codes_url, params: { short_code: { url: "example" } }
    end
    assert_equal ["Url must be a valid http(s) url"], flash[:alert]
  end

  def test_show
    @shorty = ShortCode.create url: @url

    assert_difference('Stat.count') do
      get short_code_url(@code), params: {}, headers: { "HTTP_USER_AGENT" => "rails/test" }
    end
    assert_redirected_to @url
    @stat = Stat.last
    assert_equal @shorty.id, @stat.short_code_id
    assert_equal "rails/test", @stat.user_agent
  end

  def test_show_invalid_code
    get short_code_url("invalid-code")
    assert_redirected_to root_url
    assert_equal ["invalid-code was not found", "feel free to create a new one!"], flash.alert
  end

  def test_create_non_unique_url
    ShortCode.create(url: @url)
    post short_codes_url, params: { short_code: { url: @url} }
    assert_redirected_to root_url
    follow_redirect!

    assert_select "input[type=url]" do
      assert_select "[value=?]", @url
    end
  end
end
