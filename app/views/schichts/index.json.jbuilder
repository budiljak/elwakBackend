json.array!(@schichts) do |schicht|
  json.array! [schicht_bezeichner(schicht), schicht.id, schicht_path(schicht, format: :json)]
end
