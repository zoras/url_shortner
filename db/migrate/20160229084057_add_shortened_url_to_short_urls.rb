class AddShortenedUrlToShortUrls < ActiveRecord::Migration
  def change
    add_column :short_urls, :shortened_url, :string
  end
end
