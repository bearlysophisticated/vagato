json.array!(@room_equipments) do |room_equipment|
  json.extract! room_equipment, :id, :room_id, :equipment_id
  json.url room_equipment_url(room_equipment, format: :json)
end
