FactoryGirl.define do
  factory :feed do
    name "Name"
    sequence :url do |n|
      "http://example.org/#{n}.rss"
    end

    before(:create) do |feed|
      if feed.url
        mock_request(feed.url)
        allow(feed).to receive(:get_host_info)
        allow(feed).to receive(:well_formed_rss).and_return true
      end
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

  factory :user do
    sequence :email do |n|
      "email#{n}@example.org"
    end
    password 'password'
  end
end
