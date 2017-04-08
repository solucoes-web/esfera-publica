require 'rails_helper'

RSpec.describe Item, type: :model do
  it "belongs to feed" do
    feed = build(:feed)
    feed.save(validate: false)
    item = create(:item, feed: feed)
    expect(item.feed).to eq feed
  end

  it "filters by tag" do
    tagged_feed = build(:feed)
    tagged_feed.tag_list.add("Tag")
    simple_feed = build(:feed)
    [tagged_feed, simple_feed].each{|feed| feed.save(validate: false)}

    tagged_item = create(:item, feed: tagged_feed)
    simple_item = create(:item, feed: simple_feed)

    expect(Item.tagged_with("Tag")).to include(tagged_item)
    expect(Item.tagged_with("Tag")).not_to include(simple_item)
  end

  it "filter most recent" do
    (feed = build(:feed)).save(validate: false)
    first = create(:item, feed: feed, published_at: Time.now)
    (1..10).each do
      create(:item, feed: feed, published_at: 2.days.ago)
    end

    expect(Item.most_recent(1)).to include(first)
    expect(Item.most_recent(1).count).to eq 1
  end
end
