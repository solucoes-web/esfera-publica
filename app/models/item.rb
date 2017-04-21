class Item < ApplicationRecord
  belongs_to :feed
  has_many :interactions

  acts_as_taggable_on :keywords

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
  scope :favourites, ->(user) {
    joins(:interactions).
    where("interactions.user_id = ? AND favourite = ?", user.id, true)
  }
  scope :bookmarks, ->(user) {
    joins(:interactions).
    where("interactions.user_id = ? AND bookmark = ?", user.id, true)
  }
  scope :history, ->(user) {
    joins(:interactions).
    where("interactions.user_id = ? AND read = ?", user.id, true)
  }

  before_save do
    get_keywords
    begin
      html = open(url).read
      get_images(html)
      get_content(html)
    rescue Exception => e
      logger.info e.message
    end
  end

  private
  def get_keywords
    # ajustei os pesos: 4 vezes para a manchete, 2 para o resumo e 1 para o conteudo
    text = (Array.new(4, name) + Array.new(2, summary) + [content]).join(' ')
    text = ActionController::Base.helpers.sanitize(text)
    keywords = OTS.parse(text, language: "pt").keywords
    self.keyword_list = (keywords - Stopwords.first)[0..4].join(', ')
    # provavelmente vou querer isso em outras linguas no futuro
  end

  def get_images(html)
    #  self.image ||= (/property="og:image" content="(.+)"/.match html)[1]
    self.image ||= OpenGraph.new(html).images.first
  end

  def get_content(html)
    self.content = Readability::Document.new(html).content
  end
end
