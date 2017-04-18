class Item < ApplicationRecord
  belongs_to :feed

  scope :feed, ->(feed) {
    where(feed: feed)
  }
end
