class Feed < ApplicationRecord
  validates :url, :name, presence: true
  validate :persistency_of_url
  validate :well_formed_rss

  before_validation do
    begin
      @rss = Feedjira::Feed.fetch_and_parse url # tenta fazer o parse do RSS
    rescue
      if url
        pismo = Pismo[url]
        if pismo
          self.url = pismo.feed # pega o endereço do RSS
          self.favicon = pismo.favicon
          self.validate
        end
      end
    ensure
      get_basic_info if @rss
    end
  end

  def well_formed_rss
    unless @rss
      errors.add(:url, "RSS inválido")
    end
  end

  def persistency_of_url
    if url_changed? && self.persisted?
      errors.add(:url, "Mudar o URL não é permitido")
    end
  end

  private
  def get_basic_info
    self.name = @rss.title if name.blank? # pega o titulo caso ainda não tenha sido feito
    self.favicon ||= Pismo[@rss.url].favicon # pega um favicon caso ainda não tenha sido feito
  end
end
