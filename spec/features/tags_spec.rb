require 'rails_helper'

RSpec.feature "Tags", type: :feature do
  before :all do
    WebMock.allow_net_connect!
  end

  before :each do
    clean_db
    @user = create(:user)
    sign_in @user
  end

  scenario "create tags" do
    VCR.use_cassette "folha" do
      allow_any_instance_of(Feed).to receive(:valid?).and_return true
      visit new_feed_path
      fill_in "Url", with: "http://feeds.folha.uol.com.br/folha/emcimadahora/rss091.xml"
      fill_in "Tags", with: "tag1, tag2"
      expect do
        click_button "Register"
      end.to change{ @user.owned_tags.count }.by 2
    end
  end

  scenario "filter items using tag" do
    tagged_feed = create(:feed, users: [@user], name: "Tagged Feed")
    simple_feed = create(:feed, users: [@user], name: "Simple Feed")
    @user.tag(tagged_feed, with: "Tag", on: :tags)
    tagged_feed.save(validate: false)

    tagged_item = create(:item, name: "Tagged Item", feed: tagged_feed)
    simple_item = create(:item, name: "Simple Item", feed: simple_feed)

    visit items_path(tag: "Tag")

    expect(page).to have_content "Tagged Item"
    expect(page).not_to have_content "Simple Item"
  end

  scenario "filter feeds using tag" do
    tagged_feed = create(:feed, users: [@user], name: "Tagged Feed")
    simple_feed = create(:feed, users: [@user], name: "Simple Feed")
    @user.tag(tagged_feed, with: "Tag", on: :tags)
    tagged_feed.save(validate: false)

    visit feeds_path(tag: "Tag")

    expect(page).to have_content "Tagged Feed"
    expect(page).not_to have_content "Simple Feed"
  end

  scenario "list tags in sidebar" do
    feed = create(:feed, users: [@user], name: "Feed")
    @user.tag(feed, with: "Tag", on: :tags)
    feed.save(validate: false)
    visit root_path

    expect(page).to have_content "Tag"
  end

  scenario "list only owned tags" do
    other = create(:user)
    feed = create(:feed, users: [@user, other])
    @user.tag(feed, with: "My tag", on: :tags)
    other.tag(feed, with: "His tag", on: :tags)
    feed.save(validate: false)
    visit root_path

    expect(page).to have_content "My tag"
    expect(page).not_to have_content "His tag"
  end
end
