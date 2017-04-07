require 'rails_helper'

RSpec.describe Item, type: :model do
  it "belongs to feed" do
    feed = build(:feed)
    feed.save(validate: false)
    item = create(:item, feed: feed)
    expect(item.feed).to eq feed
  end

end
