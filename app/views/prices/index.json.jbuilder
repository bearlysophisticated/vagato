json.array!(@prices) do |price|
  json.extract! price, :id, :value, :currency, :ifa, :vat, :room_id
  json.url price_url(price, format: :json)
end
