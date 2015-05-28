json.array!(@rapports) do |rapport|
  json.array! [rapport_bezeichner(rapport), rapport_path(rapport, format: :json)]
end
