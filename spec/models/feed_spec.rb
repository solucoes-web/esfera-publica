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
end
