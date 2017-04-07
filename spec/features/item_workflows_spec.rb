require 'rails_helper'

RSpec.feature "ItemWorkflows", type: :feature do
  before :all do
    WebMock.disable_net_connect!(allow_localhost: true)
    stub_request(:get, 'http://example.org').to_return(status: 200)
  end

  before :each do
    clean_db
    @feed = build(:feed, url: "http://example.org")
    @feed.save(validate: false)
    @item = create(:item, feed: @feed, name: "title")
  end

  scenario "list items" do
    visit items_path
    expect(page).to have_content("title")
  end

  scenario "list items of a feed" do
    visit feed_path @feed.id
    expect(page).to have_content("title")
  end

  scenario "show item" do
    visit feed_path @feed.id
    click_link "Ler aqui"

    expect(page).to have_css('.modal')
  end
end
