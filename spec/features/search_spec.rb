require 'rails_helper'

RSpec.feature "Search", type: :feature do
  scenario "search items" do
    (feed = build(:feed)).save(validate: false)
    should_find1 = create(:item, feed: feed, name: "First test")
    should_find2 = create(:item, feed: feed, summary: "Second test")
    should_not_find1 = create(:item, feed: feed, name: "Diferent thing")
    should_not_find2 = create(:item, feed: feed, summary: "Another thing")

    visit root_path
    fill_in "search", with: "test"
    first(':has(.glyphicon-search)').click

    expect(page).to have_content should_find1.name
    expect(page).to have_content should_find2.summary
    expect(page).not_to have_content should_not_find1.name
    expect(page).not_to have_content should_not_find2.summary
  end

  scenario "search feeds" do
    should_find = build(:feed, name: "First test")
    should_not_find = build(:feed, name: "Different thing")
    [should_find, should_not_find].each{ |feed| feed.save(validate: false) }

    visit feeds_path
    fill_in "search", with: "test"
    first(':has(.glyphicon-search)').click

    expect(page).to have_content should_find.name
    expect(page).not_to have_content should_not_find.name
  end

  scenario "search feed inside tag" do
    should_find = build(:feed, name: "First test")
    should_not_find1 = build(:feed, name: "Second test")
    should_not_find2 = build(:feed, name: "Different thing")
    should_find.tag_list.add("Tag")
    should_not_find2.tag_list.add("Tag")
    [should_find, should_not_find1, should_not_find2].each do |feed|
      feed.save(validate: false)
    end

    visit feeds_path
    click_link "Tag"
    fill_in "search", with: "test"
    first(':has(.glyphicon-search)').click

    expect(page).to have_content should_find.name
    expect(page).not_to have_content should_not_find1.name
    expect(page).not_to have_content should_not_find2.name
  end
end
