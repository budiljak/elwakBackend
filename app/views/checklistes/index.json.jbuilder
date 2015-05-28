json.array!(@checklistes) do |checkliste|
  json.array! [checkliste_bezeichner(checkliste), checkliste_path(checkliste, format: :json)]
end
