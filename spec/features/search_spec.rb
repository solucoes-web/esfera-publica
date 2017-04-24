require 'rails_helper'

RSpec.feature "Search", type: :feature do
  before :each do
    @user = create(:user)
    sign_in @user
  end

  scenario "search items" do
    feed = create(:feed, users: [@user])
    should_find1 = create(:item, feed: feed, name: "First test")
    should_find2 = create(:item, feed: feed, summary: "Second test")
    should_not_find1 = create(:item, feed: feed, name: "Diferent thing")
    should_not_find2 = create(:item, feed: feed, summary: "Another thing")

    visit root_path
    fill_in "search", with: "test"
    first('#search :has(.glyphicon-search)').click

    expect(page).to have_content should_find1.name
    expect(page).to have_content should_find2.summary
    expect(page).not_to have_content should_not_find1.name
    expect(page).not_to have_content should_not_find2.summary
  end

  scenario "search feeds" do
    should_find = create(:feed, users: [@user], name: "First test")
    should_not_find = create(:feed, users: [@user], name: "Different thing")

    visit feeds_path
    fill_in "search", with: "test"
    first('#search :has(.glyphicon-search)').click

    expect(page).to have_content should_find.name
    expect(page).not_to have_content should_not_find.name
  end

  scenario "search feed inside tag" do
    should_find = create(:feed, users: [@user], name: "First test")
    should_not_find1 = create(:feed, users: [@user], name: "Second test")
    should_not_find2 = create(:feed, users: [@user], name: "Different thing")
    @user.tag(should_find, with: "Tag", on: :tags)
    @user.tag(should_not_find2, with: "Tag", on: :tags)

    [should_find, should_not_find2].each do |feed|
      feed.save(validate: false)
    end

    visit feeds_path
    click_link "Tag"
    fill_in "search", with: "test"
    first('#search :has(.glyphicon-search)').click

    expect(page).to have_content should_find.name
    expect(page).not_to have_content should_not_find1.name
    expect(page).not_to have_content should_not_find2.name
  end

  scenario "clear search" do
    should_find1 = create(:feed, users: [@user], name: "First test")
    should_find2 = create(:feed, users: [@user], name: "Different thing")
    should_not_find = create(:feed, users: [@user], name: "Second test")

    @user.tag(should_find1, with: "Tag", on: :tags)
    @user.tag(should_find2, with: "Tag", on: :tags)
    [should_find1, should_find2].each do |feed|
      feed.save(validate: false)
    end

    visit feeds_path
    click_link "Tag"
    fill_in "search", with: "test"
    first('#search :has(.glyphicon-search)').click
    first('#search :has(.glyphicon-remove)').click

    expect(page).to have_content should_find1.name
    expect(page).to have_content should_find2.name
    expect(page).not_to have_content should_not_find.name
  end
end
