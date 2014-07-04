json.array!(@kontrollgangs) do |kontrollgang|
  json.extract! kontrollgang, :id, :wachbuch_eintrag_id, :uhrzeit, :bemerkung, :position
  json.url kontrollgang_url(kontrollgang, format: :json)
end
