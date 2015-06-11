json.array!(@checklistes) do |checkliste|
  json.array! [checkliste_bezeichner(checkliste), checkliste_path_for_list(checkliste)]
end
