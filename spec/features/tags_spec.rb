require 'rails_helper'

RSpec.feature "Tags", type: :feature do
  before :all do
    WebMock.allow_net_connect!
  end

  before :each do
    clean_db
  end

  scenario "create a new tag for specific feed" do
    VCR.use_cassette "folha" do
      feed = build(:feed, url: "http://feeds.folha.uol.com.br/folha/emcimadahora/rss091.xml")
      feed.save(validate: false)
      visit feeds_path
      first(':has(.glyphicon-cog)').click

      fill_in "Tags", with: "tag1, tag2"
      expect do
        click_button "Register"
      end.to change{feed.tags.count}.by 2
    end
  end

  scenario "filter items using tag" do
    tagged_feed = build(:feed, name: "Tagged Feed")
    tagged_feed.tag_list.add("Tag")
    simple_feed = build(:feed, name: "Simple Feed")
    [tagged_feed, simple_feed].each{|feed| feed.save(validate: false)}

    tagged_item = create(:item, name: "Tagged Item", feed: tagged_feed)
    simple_item = create(:item, name: "Simple Item", feed: simple_feed)

    visit tag_items_path "Tag"

    expect(page).to have_content "Tagged Item"
    expect(page).not_to have_content "Simple Item"
  end

  scenario "filter feeds using tag" do
    tagged_feed = build(:feed, name: "Tagged Feed")
    tagged_feed.tag_list.add("Tag")
    simple_feed = build(:feed, name: "Simple Feed")
    [tagged_feed, simple_feed].each{|feed| feed.save(validate: false)}

    visit tag_feeds_path "Tag"

    expect(page).to have_content "Tagged Feed"
    expect(page).not_to have_content "Simple Feed"
  end

  scenario "list tags in sidebar" do
    feed = build(:feed, name: "Feed")
    feed.tag_list.add("Tag")
    feed.save(validate: false)
    visit root_path

    expect(page).to have_content "Tag"
  end
end
