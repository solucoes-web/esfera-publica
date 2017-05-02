require 'rails_helper'

RSpec.describe Item, type: :model do
  it "belongs to feed" do
     (feed = build(:feed)).save(validate: false)
     item = create(:item, feed: feed)
     expect(item.feed).to eq feed
   end

  it "filter most recent" do
   first = create(:item, published_at: Time.now)
   (1..10).each do
     create(:item, published_at: 2.days.ago)
   end

   expect(Item.latest(1)).to include(first)
   expect(Item.latest(1).count).to eq 1
 end

 it "search keyword" do
   should_find1 = create(:item, name: "First test")
   should_find2 = create(:item, summary: "Second test")
   should_not_find = create(:item, name: "Different thing")

   expect(Item.search('test')).to include should_find1
   expect(Item.search('test')).to include should_find2
   expect(Item.search('test')).not_to include should_not_find
 end

 it "filters by feed" do
   feed1 = create(:feed, name: "Primeiro feed")
   feed2 = create(:feed, name: "Segundo feed")

   should_find1 = create(:item, feed: feed1, name: "First test")
   should_find2 = create(:item, feed: feed1, summary: "Second test")
   should_not_find1 = create(:item, feed: feed2, name: "Different thing")
   should_not_find2 = create(:item, feed: feed2, name: "Another thing")

   expect(Item.feed(feed1)).to include should_find1
   expect(Item.feed(feed1)).to include should_find2
   expect(Item.feed(feed1)).not_to include should_not_find1
   expect(Item.feed(feed1)).not_to include should_not_find2
 end

 it "filters by date published" do
   should_find1 = create(:item, published_at: 4.days.ago, name: "Primeiro")
   should_find2 = create(:item, published_at: 5.days.ago, name: "Segundo")
   should_not_find1 = build(:item, published_at: 1.days.ago, name: "Terceiro")
   should_not_find2 = build(:item, published_at: 2.days.ago, name: "Quarto")

   expect(Item.date_published(3.days.ago)).to include should_find1
   expect(Item.date_published(3.days.ago)).to include should_find2
   expect(Item.date_published(3.days.ago)).not_to include should_not_find1
   expect(Item.date_published(3.days.ago)).not_to include should_not_find2
 end


end
