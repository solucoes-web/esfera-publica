require 'rails_helper'

RSpec.feature "Calendar", type: :feature do
  before :each do
    @user = create(:user)
    sign_in @user
  end

  scenario "Filter items by date" do
     feed = create(:feed, users: [@user])
     should_find1 = create(:item, feed: feed, published_at: 4.days.ago, name: "Primeiro")
     should_find2 = create(:item, feed: feed, published_at: 5.days.ago, name: "Segundo")
     should_not_find1 = create(:item, feed: feed, published_at: 1.days.ago, name: "Terceiro")
     should_not_find2 = create(:item, feed: feed, published_at: 2.days.ago, name: "Quarto")

     visit root_path
     date = 3.days.ago.strftime("%d/%m/%Y")
     fill_in "calendar", with: date
     first('#calendar :has(.glyphicon-calendar)').click

     expect(page).to have_content should_find1.name
     expect(page).to have_content should_find2.name
     expect(page).not_to have_content should_not_find1.name
     expect(page).not_to have_content should_not_find2.name
  end

  scenario "Invalid date" do
     visit root_path
     fill_in "calendar", with: "Formato ruim"
     first('#calendar :has(.glyphicon-calendar)').click

     expect(page).to have_content "Data inválida"
   end

  scenario "Accumulate search and date filters" do
    feed = create(:feed, users: [@user])
    should_find = create(:item, feed: feed, published_at: 4.days.ago, name: "Teste 1")
    should_not_find1 = create(:item, feed: feed, published_at: 5.days.ago, name: "Segundo")
    should_not_find2 = create(:item, feed: feed, published_at: 1.days.ago, name: "Teste 3")
    should_not_find3 = create(:item, feed: feed, published_at: 2.days.ago, name: "Teste 4")

    visit root_path
    date = 3.days.ago.strftime("%d/%m/%Y")
    fill_in "calendar", with: date
    first('#calendar :has(.glyphicon-calendar)').click
    fill_in "search", with: "Teste"
    first('#search :has(.glyphicon-search)').click

    expect(page).to have_content should_find.name
    expect(page).not_to have_content should_not_find1.name
    expect(page).not_to have_content should_not_find2.name
    expect(page).not_to have_content should_not_find3.name
  end
end
