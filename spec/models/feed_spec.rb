require 'rails_helper'

RSpec.describe Feed, type: :model do
  it "does not allow a feed with no url" do
    feed = build(:feed, url: nil)
    expect(feed).to be_invalid
  end

  it "does not allow a feed with no name" do
    feed = build(:feed, name: nil)
    expect(feed).to be_invalid
  end

  it "does not allow to update url" do
    feed = create(:feed, url: "http://example.com")
    feed.url = "http://example.org"
    expect(feed).to be_invalid
  end
end
