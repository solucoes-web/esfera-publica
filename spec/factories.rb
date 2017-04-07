FactoryGirl.define do
  factory :feed do
    name "Name"
    sequence :url do |n|
      "http://example.org/#{n}.rss"
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
  end
end
