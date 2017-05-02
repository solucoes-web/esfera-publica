class Item < ApplicationRecord
  belongs_to :feed

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
  scope :cumulative_filters, -> (params) {
    search = params[:search] ? search(params[:search]) : Item
    unless params[:calendar].blank?
      date = strip_date(params[:calendar])
      search = search.date_published(date)
    end
    search
  }

  private
  def self.strip_date(date)
   begin
     return Date.strptime(date, "%d/%m/%Y")
   rescue
     raise ArgumentError, 'Data inválida'
    end
  end
end
