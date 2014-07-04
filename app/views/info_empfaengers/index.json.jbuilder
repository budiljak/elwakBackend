json.array!(@info_empfaengers) do |info_empfaenger|
  json.extract! info_empfaenger, :id, :info_id, :benutzer_id, :gelesen
  json.url info_empfaenger_url(info_empfaenger, format: :json)
end
