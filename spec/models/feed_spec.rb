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

  it "gets basic info from rss" do
    feed = build(:feed, url: "http://feeds.folha.uol.com.br/folha/emcimadahora/rss091.xml")
    VCR.use_cassette "folha" do
      feed.get_basic_info
      expect(feed.name).not_to be_nil
      expect(feed.favicon).not_to be_nil
    end
  end

  it "gets basic info from host" do
    feed = build(:feed, url: "https://www.propublica.org/")
    VCR.use_cassette "propublica" do
      feed.get_basic_info
      expect(feed.name).not_to be_nil
      expect(feed.favicon).not_to be_nil
    end
  end

  it "raises exception in invalid url" do
    feed = build(:feed, url: "http://example.com")
    VCR.use_cassette "example" do
      expect{ feed.get_basic_info }.to raise_error("RSS inválido")
    end
  end
end
