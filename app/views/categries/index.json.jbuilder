json.array!(@categries) do |categry|
  json.extract! categry, :id, :name, :code, :value, :accommodation_id
  json.url categry_url(categry, format: :json)
end
