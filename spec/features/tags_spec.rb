require 'rails_helper'

RSpec.feature "Tags", type: :feature do
  scenario "create a new tag for specific feed" do
    feed = build(:feeds)
    feed.save(validate: false)
    visit feeds_path
    first(':has(.glyphicon-cog)').click

    fill_in "Tags", with: "tag1, tag2"
    expect(feed.tags.count).to eq 2
  end

  scenario "filter items using tag" do
    tag = create(:tag, name: "Tag")
    tagged_feed = build(:feeds, name: "Tagged Feed", tags: [tag])
    simple_feed = build(:feeds, name: "Simple Feed", tags: nil)
    [tagged_feed, simple_feed].each{|feed| feed.save(validate: false) }

    tagged_item = create(:item, name: "Tagged Item", feed: tagged_feed)
    simple_item = create(:item, name: "Simple Item", feed: simple_feed)

    visit tag_show_path tag

    expect(page).to have_content "Tagged Item"
    expect(page).not_to have_content "Simple Item"
  end

  scenario "list tags in layout" do
    tag = create(:tag, name: "Tag")
    visit root_path

    expect(page).to have_content "Tag"
  end
end
