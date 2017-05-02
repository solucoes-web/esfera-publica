require 'rails_helper'

RSpec.describe Feed, type: :model do
  before :each do
    clean_db
    (@feed = build(:feed)).save(validate: false)
    @item = create(:item, feed: @feed)
  end

  it "has many items" do
    expect(@feed.items).to eq [@item]
  end

  it "items depend on feed to exist" do
    expect do
      @feed.destroy
    end.to change{Item.count}.by -1
  end

  it "search keyword" do
    should_find1 = create(:feed, name: "First test")
    should_find2 = create(:feed, name: "Second test")
    should_not_find = create(:feed, name: "Different thing")

    expect(Feed.search('test')).to include should_find1
    expect(Feed.search('test')).to include should_find2
    expect(Feed.search('test')).not_to include should_not_find
  end
end
