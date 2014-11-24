json.array!(@accommodation_equipments) do |accommodation_equipment|
  json.extract! accommodation_equipment, :id, :accommodation_id, :equipment_id
  json.url accommodation_equipment_url(accommodation_equipment, format: :json)
end
