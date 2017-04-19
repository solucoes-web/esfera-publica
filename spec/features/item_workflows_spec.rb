require 'rails_helper'

RSpec.feature "ItemWorkflows", type: :feature do
  before :each do
    clean_db
    @user = create(:user)
    sign_in @user
    @feed = build(:feed, users: [@user], url: "http://example.org")
    @feed.save(validate: false)
    @item = create(:item, feed: @feed, name: "title")
  end

  scenario "list items" do
    visit items_path
    expect(page).to have_content("title")
  end

  scenario "list feed items" do
    visit items_path @feed.id
    expect(page).to have_content("title")
  end

  scenario "show item" do
    visit items_path @feed.id
    click_link "Ler aqui"

    expect(page).to have_css('.modal')
  end
end
