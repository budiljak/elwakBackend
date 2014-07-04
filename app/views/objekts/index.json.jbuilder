json.array!(@objekts) do |objekt|
  json.extract! objekt, :id, :bezeichner, :inaktiv
  json.url objekt_url(objekt, format: :json)
end
