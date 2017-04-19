class Item < ApplicationRecord
  belongs_to :feed

  #  preciso filtrar pelo usuário
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
  scope :date_published, ->(date) {
    where("published_at <= ?", date)
  }

  before_save do
    begin
      html = open(url).read
    #  self.image ||= (/property="og:image" content="(.+)"/.match html)[1]
      self.image ||= OpenGraph.new(html).images.first
      self.content = Readability::Document.new(html).content
    rescue Exception => e
      logger.info e.message
    end
  end
end
