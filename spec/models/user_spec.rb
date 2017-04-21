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

  it "(un)favourites item" do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)

    user.favourite(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.favourite?).to be_truthy

    user.unfavourite(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.favourite?).to be_falsey
  end

  it "(un)bookmark item" do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)

    user.bookmark(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.bookmark?).to be_truthy

    user.unbookmark(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.bookmark?).to be_falsey
  end

  it "(un)read item" do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)

    user.read(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.read?).to be_truthy

    user.unread(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.read?).to be_falsey
  end

  it "toggle favourites item" do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)

    user.toggle_favourite(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.favourite?).to be_truthy

    user.toggle_favourite(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.favourite?).to be_falsey
  end

  it "toggle bookmark item" do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)

    user.toggle_bookmark(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.bookmark?).to be_truthy

    user.toggle_bookmark(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.bookmark?).to be_falsey
  end

  it "toggle read item" do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)

    user.toggle_read(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.read?).to be_truthy

    user.toggle_read(item)
    inter = Interaction.find_by(user: user, item: item)
    expect(inter.read?).to be_falsey
  end

  it 'has favourite items' do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    should_find = create(:item, feed: feed)
    should_not_find = create(:item, feed: feed)
    user.feeds << feed
    user.favourite(should_find)

    expect(user.favourites).to include should_find
    expect(user.favourites).not_to include should_not_find
  end

  it 'has bookarked items' do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    should_find = create(:item, feed: feed)
    should_not_find = create(:item, feed: feed)
    user.feeds << feed
    user.bookmark(should_find)

    expect(user.bookmarks).to include should_find
    expect(user.bookmarks).not_to include should_not_find
  end

  it 'has read items' do
    user = create(:user)
    (feed = build(:feed)).save(validate: false)
    should_find = create(:item, feed: feed)
    should_not_find = create(:item, feed: feed)
    user.feeds << feed
    user.read(should_find)

    expect(user.history).to include should_find
    expect(user.history).not_to include should_not_find
  end
end
