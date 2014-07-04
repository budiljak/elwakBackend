json.array!(@benutzers) do |benutzer|
  json.extract! benutzer, :id, :login, :passwort, :vorname, :nachname, :typ, :inaktiv
  json.url benutzer_url(benutzer, format: :json)
end
