require 'rails_helper'

RSpec.describe Interaction, type: :model do
  it "belongs to user" do
    user = create(:user)
    inter = Interaction.new(user: user, item: create(:item))
    expect(inter.user).to eq user
  end

  it "belongs to item" do
    item = create(:item)
    inter = Interaction.new(user: create(:user), item: item)
    expect(inter.item).to eq item
  end
end
