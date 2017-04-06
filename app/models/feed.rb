class Feed < ApplicationRecord
  validates :url, :name, presence: true
  validate :persistency_of_url
  validate :well_formed_rss

  before_validation do
    begin
      @rss = Feedjira::Feed.fetch_and_parse url # tenta fazer o parse do RSS
    rescue
      get_host_info if url # pega as informações do host
    ensure
      get_rss_info if @rss # pega as informações do RSS
    end
  end

  def well_formed_rss
    unless @rss
      errors.add(:url, "RSS inválido")
    end
  end

  def persistency_of_url
    if url_changed? && self.persisted? # não permite mudar o URL de um registro
      errors.add(:url, "Mudar o URL não é permitido")
    end
  end

  private
  def get_host_info
    pismo = Pismo[url]
    if pismo
      self.url = pismo.feed # pega o endereço do RSS da pagina
      self.favicon = pismo.favicon # pega o favicon da pagina
      self.validate # tenta novamente fazer o parse do RSS
    end
  end

  def get_rss_info
    self.name = @rss.title if name.blank? # pega o titulo do RSS
    self.favicon ||= Pismo[@rss.url].favicon # pega um favicon caso ainda não tenha sido feito
  end
end
