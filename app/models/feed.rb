class Feed < ApplicationRecord
  validates :url, :name, presence: true
  validate :persistency_of_url

  private

  def persistency_of_url
    if url_changed? && self.persisted?
      errors.add(:url, "Change URL is not allowed")
    end
  end
end
