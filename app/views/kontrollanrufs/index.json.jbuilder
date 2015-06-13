json.array!(@kontrollanrufs) do |kontrollanruf|
  json.array! [kontrollanruf.uhrzeit, kontrollanruf.bemerkung, kontrollanruf_path_for_list(kontrollanruf), kontrollanruf_path(kontrollanruf)]
end
