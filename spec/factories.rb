FactoryGirl.define do
  factory :feed do
    name "Name"
    sequence :url do |n|
      "http://example.org/#{n}.rss"
    end
  end
end
