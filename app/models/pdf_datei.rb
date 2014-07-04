class PdfDatei < ActiveRecord::Base
  belongs_to :objekt
  mount_uploader :datei, PdfUploader
end
