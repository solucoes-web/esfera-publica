require 'rails_helper'

RSpec.describe Feed, type: :model do
  it "has many items" do
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)

    expect(feed.items).to eq [item]
  end

  it "items depend on feed to exist" do
    (feed = build(:feed)).save(validate: false)
    item = create(:item, feed: feed)

    expect do
      feed.destroy
    end.to change{Item.count}.by -1
  end

  it "feed has many tags" do
    feed = build(:feed)
    expect do
      feed.tag_list.add("tag 1, tag 2", parse: true)
      feed.save(validate: false)
    end.to change{feed.tags.count}.by 2
  end

  it "tag has many feeds" do
    feed = build(:feed)
    expect do
      feed.tag_list.add("tag 1, tag 2", parse: true)
      feed.save(validate: false)
    end.to change{Feed.tagged_with("tag 1").count}.by 1
  end

  it "search keyword" do
    should_find1 = build(:feed, name: "First test")
    should_find2 = build(:feed, name: "Second test")
    should_not_find = build(:feed, name: "Different thing")
    [should_find1, should_find2].each{ |feed| feed.save(validate: false) }

    expect(Feed.search('test')).to include should_find1
    expect(Feed.search('test')).to include should_find2
    expect(Feed.search('test')).not_to include should_not_find
  end

  context "mocking internet" do
    before(:each) do
      WebMock.disable_net_connect!(allow_localhost: true)
      @url = "http://example.org"
      stub_request(:get, "#{@url}/rss").to_return(status: 200) # stubing a request
      stub_request(:get, @url).to_return(status: 200) # stubing a request

      @rss = double(:rss, url: @url, title: nil) # mocking an object
      # stubing a method
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with("#{@url}/rss").and_return(@rss)
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with(@url).and_throw(Exception)
    end

    it "does not allow a feed with no url" do
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with(nil).and_throw(Exception)
      feed = build(:feed, url: nil)
      expect(feed).to be_invalid
    end

    it "does not allow a feed with no name" do
      feed = build(:feed, name: nil, url:"#{@url}/rss")
      expect(feed).to be_invalid
    end

    it "does not allow to update URL" do
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with("another_url").and_return(@rss)
      feed = create(:feed, url: "#{@url}/rss")
      feed.url = "another_url"
      expect(feed).to be_invalid
    end

    it "does not allow invalid RSS" do
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with(nil).and_throw(Exception)
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with("#{@url}/rss").and_throw(Exception)
      feed = build(:feed, url: "#{@url}/rss")

      expect(feed).to be_invalid
    end

    it "fetches and parses RSS after initialize" do
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with("#{@url}/rss").and_return(@rss)
      feed = create(:feed, url: "#{@url}/rss")

      expect(feed.instance_variable_get(:@rss)).to eq @rss
    end

    it "follows links to RSS from URL" do
      allow(Feedjira::Feed).to receive(:fetch_and_parse).with("#{@url}/rss").and_return(@rss)
      allow(Pismo[@url]).to receive(:feed).and_return("#{@url}/rss")
      feed = create(:feed, url: @url)

      expect(feed.url).to eq "#{@url}/rss"
      expect(feed.instance_variable_get(:@rss)).to eq @rss
    end

    it "gets rss info" do
      @rss = double(:rss, url: @url, title: "name") # mocking an object
      feed = build(:feed, url: @url, name: nil)
      feed.instance_variable_set(:@rss, @rss)
      allow(Pismo[@url]).to receive(:favicon).and_return("#{@url}/favicon.png")

      feed.instance_eval{ get_rss_info }

      expect(feed.name).to eq "name"
      expect(feed.favicon).to eq "#{@url}/favicon.png"
    end

    it "gets host info" do
      feed = build(:feed, url: @url, name: nil)
      feed.instance_variable_set(:@rss, @rss)
      allow(Pismo[@url]).to receive(:favicon).and_return("#{@url}/favicon.png")
      allow(Pismo[@url]).to receive(:feed).and_return("#{@url}/rss")

      feed.instance_eval{ get_host_info }

      expect(feed.url).to eq "#{@url}/rss"
      expect(feed.favicon).to eq "#{@url}/favicon.png"
    end
  end

  context "new items" do
    before(:each) do
      @entry = double(title: 'name',
                      summary: 'summary',
                      url: 'http://example.com',
                      published: 3.day.ago,
                      id: 1,
                      image: 'http://example.com/img.png')
      mock_request(@entry.url)
    end

    it "adds items" do
      feed = build(:feed)
      feed.save(validate: false)
      @rss = double(:rss, entries: [@entry])

      feed.instance_variable_set(:@rss, @rss)
      expect do
        feed.instance_eval{ update_items }
      end.to change{feed.items.count}.by 1
    end
  end
end
