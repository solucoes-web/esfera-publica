class Item < ApplicationRecord
  belongs_to :feed

  scope :tagged_with, ->(tag) {
       joins("INNER JOIN taggings ON taggings.taggable_id = items.feed_id\
              INNER JOIN tags ON tags.id = taggings.tag_id AND\
              taggings.taggable_type = 'Feed'").where("tags.name = ?", tag)
  } # será que existe uma forma mais elegante?
  scope :latest, ->(number) {
    order(published_at: :desc).limit(number)
  }
  scope :search, ->(keyword) {
    where("items.name LIKE ? OR items.summary LIKE ?", "%#{keyword}%", "%#{keyword}%")
  }
  scope :feed, ->(feed) {
    where(feed: feed)
  }
end
