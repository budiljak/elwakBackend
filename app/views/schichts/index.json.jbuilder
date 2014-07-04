json.array!(@schichts) do |schicht|
  json.extract! schicht, :id, :objekt_id, :benutzer_id, :datum, :uhrzeit_beginn, :uhrzeit_ende
  json.url schicht_url(schicht, format: :json)
end
