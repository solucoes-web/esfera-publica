require 'rails_helper'

RSpec.describe Item, type: :model do
  it "belongs to feed" do
    (feed = build(:feed)).save(validate: false)
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

    expect(Item.latest(1)).to include(first)
    expect(Item.latest(1).count).to eq 1
  end

  it "search keyword" do
    (feed = build(:feed)).save(validate: false)
    should_find1 = create(:item, feed: feed, name: "First test")
    should_find2 = create(:item, feed: feed, summary: "Second test")
    should_not_find = create(:item, feed: feed, name: "Different thing")

    expect(Item.search('test')).to include should_find1
    expect(Item.search('test')).to include should_find2
    expect(Item.search('test')).not_to include should_not_find
  end

  it "filters by feed" do
    feed1 = build(:feed, name: "Primeiro feed")
    feed2 = build(:feed, name: "Segundo feed")
    [feed1, feed2].each{|feed| feed.save(validate: false)}

    should_find1 = create(:item, feed: feed1, name: "First test")
    should_find2 = create(:item, feed: feed1, summary: "Second test")
    should_not_find1 = create(:item, feed: feed2, name: "Different thing")
    should_not_find2 = create(:item, feed: feed2, name: "Another thing")

    expect(Item.feed(feed1)).to include should_find1
    expect(Item.feed(feed1)).to include should_find2
    expect(Item.feed(feed1)).not_to include should_not_find1
    expect(Item.feed(feed1)).not_to include should_not_find2
  end

  it "filters by date published" do
    (feed = build(:feed)).save(validate: false)
    should_find1 = create(:item, feed: feed, published_at: 4.days.ago, name: "Primeiro")
    should_find2 = create(:item, feed: feed, published_at: 5.days.ago, name: "Segundo")
    should_not_find1 = build(:item, feed: feed, published_at: 1.days.ago, name: "Terceiro")
    should_not_find2 = build(:item, feed: feed, published_at: 2.days.ago, name: "Quarto")

    expect(Item.date_published(3.days.ago)).to include should_find1
    expect(Item.date_published(3.days.ago)).to include should_find2
    expect(Item.date_published(3.days.ago)).not_to include should_not_find1
    expect(Item.date_published(3.days.ago)).not_to include should_not_find2
  end

  it "gets image from open graph" do
    (feed = build(:feed)).save(validate: false)
    img = 'http://example.com/imgs'
    og = double(:og, images: [img])
    url = 'http://example.com'
    mock_request(url)
    allow(OpenGraph).to receive(:new).with("").and_return(og)
    item = create(:item, feed: feed, url: url)

    expect(item.image).to eq img
  end

  it "gets content from item page" do
    (feed = build(:feed)).save(validate: false)
    content = "Lorem ipsum"
    readability = double(:readability, content: content)
    url = 'http://example.com'
    mock_request(url)
    allow(Readability::Document).to receive(:new).with("").and_return(readability)
    item = create(:item, feed: feed, url: url)

    expect(item.content).to eq content
  end

  it "gets keywords" do
    (feed = build(:feed)).save(validate: false)
    parsed = double(:parsed, keywords: %w(lorem ipsum))
    item = create(:item, feed: feed, name: "Title", summary: "lorem ipsum")
    text = (Array.new(4, item.name) + Array.new(2, item.summary)).join(' ')
    allow(OTS).to receive(:parse).with(text, language: "pt").and_return(parsed)

    expect(item.keyword_list).to match_array %w(title lorem ipsum)
  end
end
