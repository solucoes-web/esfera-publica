require 'rails_helper'

RSpec.feature "ItemWorkflows", type: :feature do
  before :each do
    clean_db
    (@feed = build(:feed, url: "http://example.org")).save(validate: false)
    @item = create(:item, feed: @feed, name: "title")
  end

  scenario "list items" do
    visit items_path

    expect(page).to have_content(@item.name)
  end

  scenario "list feed items" do
    visit items_path @feed.id

    expect(page).to have_content(@item.name)
  end
end
