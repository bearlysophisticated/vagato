json.array!(@serviices) do |serviice|
  json.extract! serviice, :id, :name, :code
  json.url serviice_url(serviice, format: :json)
end
