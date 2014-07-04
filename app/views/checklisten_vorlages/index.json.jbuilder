json.array!(@checklisten_vorlages) do |checklisten_vorlage|
  json.extract! checklisten_vorlage, :id, :objekt_id, :bezeichner, :version, :inaktiv, :position
  json.url checklisten_vorlage_url(checklisten_vorlage, format: :json)
end
