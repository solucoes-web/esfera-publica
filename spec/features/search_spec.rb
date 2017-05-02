require 'rails_helper'

RSpec.feature "Search", type: :feature do
  scenario "search items" do
    feed = create(:feed)
    should_find1 = create(:item, feed: feed, name: "First test")
    should_find2 = create(:item, feed: feed, summary: "Second test")
    should_not_find1 = create(:item, feed: feed, name: "Diferent thing")
    should_not_find2 = create(:item, feed: feed, summary: "Another thing")

    visit items_path
    fill_in "search", with: "test"
    first('#search :has(.glyphicon-search)').click

    expect(page).to have_content should_find1.name
    expect(page).to have_content should_find2.summary
    expect(page).not_to have_content should_not_find1.name
    expect(page).not_to have_content should_not_find2.summary
  end

  scenario "search feeds" do
    should_find = create(:feed, name: "First test")
    should_not_find = create(:feed, name: "Different thing")

    visit feeds_path
    fill_in "search", with: "test"
    first('#search :has(.glyphicon-search)').click

    expect(page).to have_content should_find.name
    expect(page).not_to have_content should_not_find.name
  end
end
