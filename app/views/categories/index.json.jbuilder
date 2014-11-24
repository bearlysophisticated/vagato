json.array!(@categories) do |category|
  json.extract! category, :id, :name, :class, :code, :accommodation_id
  json.url category_url(category, format: :json)
end
