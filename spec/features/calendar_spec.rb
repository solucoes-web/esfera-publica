require 'rails_helper'

RSpec.feature "Calendar", type: :feature do
  scenario "Filter items by date" do
     feed = create(:feed)
     should_find1 = create(:item, feed: feed, published_at: 4.days.ago, name: "Primeiro")
     should_find2 = create(:item, feed: feed, published_at: 5.days.ago, name: "Segundo")
     should_not_find1 = create(:item, feed: feed, published_at: 1.days.ago, name: "Terceiro")
     should_not_find2 = create(:item, feed: feed, published_at: 2.days.ago, name: "Quarto")

     visit items_path
     date = 3.days.ago.strftime("%d/%m/%Y")
     fill_in "calendar", with: date
     first('#calendar :has(.glyphicon-calendar)').click

     expect(page).to have_content should_find1.name
     expect(page).to have_content should_find2.name
     expect(page).not_to have_content should_not_find1.name
     expect(page).not_to have_content should_not_find2.name
  end
end
