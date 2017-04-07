json.extract! item, :id, :name, :summary, :url, :published_at, :guid, :feed, :created_at, :updated_at
json.url item_url(item, format: :json)
