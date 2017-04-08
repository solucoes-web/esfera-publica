require 'rails_helper'

RSpec.describe ApplicationHelper, type: :helper do
  it "formats date" do
    date = DateTime.new(2017, 4, 3, 13, 30, 0)
    expect(default_date_format date).to eq "03/04/17 13:30"
  end

  it "counts items from tagged feed" do
    tagged_feed = build(:feed)
    tagged_feed.tag_list.add("Tag")
    simple_feed = build(:feed)
    [tagged_feed, simple_feed].each{|feed| feed.save(validate: false)}

    tagged_item = create(:item, feed: tagged_feed)
    simple_item = create(:item, feed: simple_feed)

    expect(items_count("Tag")).to eq 1
  end
end
