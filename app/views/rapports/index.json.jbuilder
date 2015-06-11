json.array!(@rapports) do |rapport|
  json.array! [rapport_bezeichner(rapport), rapport_path_for_list(rapport)]
end
