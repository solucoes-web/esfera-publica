require 'rails_helper'

RSpec.feature "Interactions", type: :feature do
  before :each do
    clean_db

    user = create(:user)
    feed = create(:feed, users: [user])
    @should_find = create(:item, feed: feed, name: "Primeiro", published_at: Time.now)
    @should_not_find = create(:item, feed: feed, name: "Segundo", published_at: 3.days.ago)

    sign_in user
  end

  scenario "Favourite item" do
    visit root_path
    first('.item :has(.glyphicon-star)').click
    click_link "favourites"

    expect(page).to have_content @should_find.name
    expect(page).not_to have_content @should_not_find.name
  end

  scenario "Bookmark item" do
    visit root_path
    first('.item :has(.glyphicon-bookmark)').click
    click_link "bookmarks"

    expect(page).to have_content @should_find.name
    expect(page).not_to have_content @should_not_find.name
  end

  scenario "Read item" do
    visit root_path
    first('.item .btn-group a').click
    visit root_path
    click_link "history"

    expect(page).to have_content @should_find.name
    expect(page).not_to have_content @should_not_find.name
  end


end
