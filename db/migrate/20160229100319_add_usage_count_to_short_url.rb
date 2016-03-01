class AddUsageCountToShortUrl < ActiveRecord::Migration
  def change
    add_column :short_urls, :usage_count, :integer, default: 0
  end
end
