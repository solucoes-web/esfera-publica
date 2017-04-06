require 'rails_helper'

RSpec.feature "FeedWorkflows", type: :feature do
  scenario "Get basic info from rss" do
    VCR.use_cassette "folha" do
      visit new_feed_path
      fill_in 'Url', with: 'http://feeds.folha.uol.com.br/emcimadahora/rss091.xml'
      click_button "Register"
      feed = Feed.first
      expect(feed.name).not_to be_blank
      #expect(feed.favicon).not_to be_blank
    end
  end
  
  scenario "Get basic info from host" do
    VCR.use_cassette "propublica" do
      visit new_feed_path
      fill_in 'Url', with: 'https://www.propublica.org/'
      click_button "Register"
      feed = Feed.first
      expect(feed.name).not_to be_blank
      expect(feed.favicon).not_to be_blank
    end
  end
end
