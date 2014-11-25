json.array!(@equipment) do |equipment|
  json.extract! equipment, :id, :name, :code
  json.url equipment_url(equipment, format: :json)
end
