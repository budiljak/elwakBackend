json.array!(@checklistes) do |checkliste|
  json.extract! checkliste, :id, :checklisten_vorlage_id, :schicht_id, :uhrzeit, :position
  json.url checkliste_url(checkliste, format: :json)
end
