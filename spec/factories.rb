FactoryGirl.define do
  factory :feed do
    name "Name"
    sequence :url do |n|
      "http://example.org/#{n}.rss"
    end

    after(:build) do |feed|
      mock_request(feed.url) if feed.url
    end
  end

  factory :item do
    feed
    name "Name"
    summary "Lorem Ipsum"
    sequence :url do |n|
      "http://example.org/#{n}"
    end
    published_at 3.days.ago
    sequence(:guid)

    after(:build) do |item|
      mock_request(item.url) if item.url
    end
  end
end
