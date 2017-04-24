require 'rails_helper'

RSpec.feature "Calendar", type: :feature do
  before :each do
    @user = create(:user)
    sign_in @user
  end

  pending "Filter items by date"
  pending "Invalid date"
  pending "Acumulate search and date filters"

  # scenario "Filter items by date" do
  #   feed = create(:feed, users: [@user])
  #   should_find1 = create(:item, feed: feed, published_at: 4.days.ago, name: "Primeiro")
  #   should_find2 = create(:item, feed: feed, published_at: 5.days.ago, name: "Segundo")
  #   should_not_find1 = create(:item, feed: feed, published_at: 1.days.ago, name: "Terceiro")
  #   should_not_find2 = create(:item, feed: feed, published_at: 2.days.ago, name: "Quarto")
  #
  #   visit root_path
  #   fill_in "calendar", with: 3.days.ago.strftime("%d/%m/%Y")
  #   first(':has(#calendar .glyphicon-calendar)').click
  #
  #   expect(page).to have_content should_find1.name
  #   expect(page).to have_content should_find2.name
  #   expect(page).not_to have_content should_not_find1.name
  #   expect(page).not_to have_content should_not_find2.name
  # end
  #
  # scenario "Invalid date" do
  #   visit root_path
  #   fill_in "calendar", with: "Formato ruim"
  #   first(':has(#calendar .glyphicon-calendar)').click
  #
  #   expect(page).to have_content "Data inválida"
  # end
end
