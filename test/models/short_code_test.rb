require 'test_helper'

class ShortCodeTest < ActiveSupport::TestCase
  def test_code_generated_short_sha1_of_url
    @shorty = ShortCode.new url: "http://example"

    assert_predicate @shorty, :valid?
    assert_equal "60d6bea", @shorty.code
  end

  def test_url_is_unique
    ShortCode.create url: "http://example"
    @shorty = ShortCode.create url: "http://example"

    refute_predicate @shorty, :valid?
    assert_equal ["has already been taken"], @shorty.errors[:url]
    assert_empty @shorty.errors[:code]
  end

  def test_code_is_unique
    @shorty = ShortCode.create url: "http://example"
    @shorty.update_attribute :url, "http://foo.bar"
    @shorty = ShortCode.create url: "http://example"

    refute_predicate @shorty, :valid?
    assert_empty @shorty.errors[:url]
    assert_equal ["has already been taken"], @shorty.errors[:code]
  end

  # a little table driven testing... VI definitely doesn't like it
  [
    ["http://a", true],
    ["https://", true],
    ["ftp://foo", false],
    ["     http://google.com", false],
    ["aefoiheafioh", false],
  ].each do |url, is_valid|
    test "url with #{"%p" % url} is #{is_valid || "not"} valid" do
      @shorty = ShortCode.new(url: url)
      if is_valid
        assert_predicate @shorty, :valid?
      else
        refute_predicate @shorty, :valid?
        assert_equal ["must be a valid http(s) url"], @shorty.errors[:url]
      end
    end
  end
end
