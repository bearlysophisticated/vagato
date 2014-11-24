json.array!(@rooms) do |room|
  json.extract! room, :id, :name, :code, :accommodation_id
  json.url room_url(room, format: :json)
end
