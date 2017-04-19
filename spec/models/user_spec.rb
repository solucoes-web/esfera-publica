require 'rails_helper'

RSpec.describe User, type: :model do
  it "has many feeds" do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    user.feeds << feed

    expect(user.feeds).to eq [feed]
  end

  it "has many items through feeds" do
    user = create(:user)
    (feed1 = build(:feed)).save(validate: false)
    (feed2 = build(:feed)).save(validate: false)
    should_find = create(:item, feed: feed1)
    should_not_find = create(:item, feed: feed2)
    user.feeds << feed1

    expect(user.items).to eq [should_find]
  end

  pending 'act-as-tagger'

#  it "act as tagger" do
#    user = create(:user)
#    (feed = build(:feed, users: [user])).save(validate: false)
#    expect do
#      user.tag(feed, with: 'tag', on: :tags)
#    end.to change{user.owned_tags.count}.by 1
#  end
end
