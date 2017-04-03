require 'rails_helper'

RSpec.feature "FeedWorkflows", type: :feature do
  before :each do
    clean_db
  end

  scenario "Register new feed" do
    VCR.use_cassette "bbc" do
      visit new_feed_path
      fill_in "Name", with: "BBC"
      fill_in "Url", with: "http://bbc.com"
      expect do
        click_button "Register"
      end.to change{ Feed.count }.by 1
      expect(page).to have_current_path(feeds_path)
    end
  end

  scenario "Destroy feed" do
    3.times{ create(:feed) }
    visit feeds_path
    expect do
      first(".destroy a").click
    end.to change{Feed.count}.by -1
  end

  scenario "Edit feed" do
    feed = create(:feed, name: "Test")
    visit edit_feed_path(feed)
    expect(find_field('Name').value).to eq 'Test'
    expect(page).to have_field('Url', disabled: true)
  end

  pending("Get basic information from feed.")

end
