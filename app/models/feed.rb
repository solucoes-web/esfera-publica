class Feed < ApplicationRecord
  has_many :items, dependent: :destroy
  validates :url, :name, presence: true

  def get_basic_info
    begin
      f = Feedjira::Feed.fetch_and_parse url
      self.name = f.title if name.blank?
      self.favicon ||= Pismo[f.url].favicon
    rescue
      get_host_info
    end
  end

  private
  def get_host_info
    pismo = Pismo[url]
    self.favicon = pismo.favicon
    self.url = pismo.feed || raise(ArgumentError.new 'RSS inválido')
    get_basic_info
  end
end
