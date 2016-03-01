class ShortUrl < ActiveRecord::Base
  validates :long_url, uniqueness: true, presence: true
  validates :shortened_url, uniqueness: true, presence: true, length: {minimum: 6}

  validate :valid_long_url?
  before_validation :generate_short_url

  def self.prune_stale_records
    ShortUrl.where("created_at >= ?", 15.days.ago).delete_all
  end

  def increment_visit
    self.update_column :usage_count, usage_count + 1
  end

  def valid_long_url?
    unless url_exist?(long_url)
      errors.add(:long_url, 'invalid url')
    end
  end

  private

  def generate_short_url
    unless shortened_url.present?
      self.shortened_url = SecureRandom.urlsafe_base64(Rails.application.secrets.short_url_length, false)
      10.times do
        link = ShortUrl.find_by_shortend_url(self.shortened_url)
        if link
          self.shortened_url = SecureRandom.urlsafe_base64(Rails.application.secrets.short_url_length, false)
        else
          break
        end
      end
    end
  end

  def url_exist?(url_string)
    url = URI.parse(url_string)
    req = Net::HTTP.new(url.host, url.port)
    req.use_ssl = (url.scheme == 'https')
    path = url.path if url.path.present?
    res = req.request_head(path || '/')
    if res.kind_of?(Net::HTTPRedirection)
      url_exist?(res['location']) # Go after any redirect and make sure you can access the redirected URL
    else
      res.code[0] != "4" #false if http code starts with 4 - error on your side.
    end
  rescue
    false #false if can't find the server
  end
end
