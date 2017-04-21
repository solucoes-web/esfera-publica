require 'rails_helper'

RSpec.describe Interaction, type: :model do
  it "belongs to user" do
    (feed = build(:feed)).save(validate: false)
    user = create(:user)
    inter = Interaction.new(user: user, item: create(:item, feed: feed))
    expect(inter.user).to eq user
  end

  it "belongs to item" do
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)
    inter = Interaction.new(user: create(:user), item: item)
    expect(inter.item).to eq item
  end
end
