json.array!(@checklisten_eintrags) do |checklisten_eintrag|
  json.extract! checklisten_eintrag, :id, :checklisten_vorlage_id, :bezeichner, :was, :wann, :typ, :position
  json.url checklisten_eintrag_url(checklisten_eintrag, format: :json)
end
