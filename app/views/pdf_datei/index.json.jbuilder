json.array!(@pdfs) do |pdf|
  json.array! [pdf.name, pdf_datei_path(pdf)]
end

