json.array!(@infos) do |info|
  json.extract! info, :id, :benutzer_id, :art, :datum, :betreff, :text, :datei
  json.url info_url(info, format: :json)
end
