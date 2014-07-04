json.array!(@wachbuch_eintrags) do |wachbuch_eintrag|
  json.extract! wachbuch_eintrag, :id, :schicht_id, :besonderheiten, :schaeden, :ausruestung_vollzaehlig, :ausruestung_funktion, :schluessel_vollzaehlig, :schluessel_bemerkung
  json.url wachbuch_eintrag_url(wachbuch_eintrag, format: :json)
end
