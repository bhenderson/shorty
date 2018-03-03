class ShortCode < ApplicationRecord

  has_many :stats

  def self.lookup(code, request)
    shorty = find_by(code: code)

    if shorty
      shorty.stats.create(user_agent: request.user_agent)
    end

    shorty
  end

  def self.valid_url?(url)
    case URI(url)
    when URI::HTTP, URI::HTTPS then true
    else false
    end
  rescue URI::Error
  end

  validates :url, presence: true, uniqueness: true
  validates :code, uniqueness: true, if: proc{ self.errors[:url].empty? }
  validate :url , :validate_url

  before_validation :generate_code, on: :create

  def to_param
    code
  end

  def generate_code
    sha1 = Digest::SHA1.new
    # optimizations might be to sort url parameters
    sha1 << url
    hex = sha1.hexdigest

    # There are different strategies for url shorteners. An easy implementation
    # would be to just use the id field from the table. This has among other
    # issues, security implications. URL Shorteners have received a lot of
    # flack lately and there is a contention between security/obscurity and
    # what's it's trying to do, mainly, provide a short url. If the url is too
    # short, it's easy to brute force other urls. A hexdigest of length 7 is a
    # good starting point and we expand on collisions
    self.code = hex.first(7)
  end

  def validate_url
    errors.add(:url, "must be a valid http(s) url") unless
      self.class.valid_url?(url)
  end

  def as_json(*opts)
    {
      code: code,
      url: url,
    }.as_json(*opts)
  end
end
