json.array!(@kontrollanrufs) do |kontrollanruf|
  json.extract! kontrollanruf, :id, :wachbuch_eintrag_id, :uhrzeit, :objekt, :bemerkung, :position
  json.url kontrollanruf_url(kontrollanruf, format: :json)
end
