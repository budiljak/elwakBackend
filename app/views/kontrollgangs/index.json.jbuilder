json.array!(@kontrollgangs) do |kontrollgang|
  json.array! [kontrollgang.uhrzeit, kontrollgang.bemerkung, kontrollgang_path_for_list(kontrollgang), kontrollgang_path(kontrollgang)]
end
