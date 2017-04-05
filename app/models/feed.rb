class Feed < ApplicationRecord
  validates :url, :name, presence: true
  validate :persistency_of_url

  def get_basic_info
    begin
      f = Feedjira::Feed.fetch_and_parse url # try to fetch RSS
      self.name = f.title if name.blank? # get title
      self.favicon ||= Pismo[f.url].favicon
    rescue
      # neste caso vou assumir que o que me passaram aponta para o RSS
      get_host_info
    end
  end

  def add_itens
    f = Feedjira::Feed.fetch_and_parse url
    add_entries(f.entries)
    f
  end

  def update_itens(f)
    f = Feedjira::Feed.update f
    add_entries(f.new_entries) if f.updated?
  end

  private

  def add_entries(entries)
    entries.each do |entry|
      unless exists? guid: entry.id
        create!(name: entry.title,
                summary: entry.summary,
                url: entry.url,
                published_at: entry.published,
                guid: entry.id)
      end
    end
  end

  def get_host_info
    pismo = Pismo[url]
    self.favicon = pismo.favicon # get favicon
    self.url = pismo.feed || raise(ArgumentError.new('RSS inválido'))
    get_basic_info
  end

  def persistency_of_url
    if url_changed? && self.persisted?
      errors.add(:url, "Change URL is not allowed")
    end
  end
end
