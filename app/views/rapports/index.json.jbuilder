json.array!(@rapports) do |rapport|
  json.extract! rapport, :id, :schicht_id, :beschreibung, :ort, :uhrzeit, :massnahmen, :position
  json.url rapport_url(rapport, format: :json)
end
