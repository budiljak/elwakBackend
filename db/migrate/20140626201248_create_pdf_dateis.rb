class CreatePdfDateis < ActiveRecord::Migration
  def change
    create_table :pdf_dateis do |t|
      t.references :objekt, index: true
      t.integer :art
      t.string :name
      t.boolean :geloescht, :null => false, :default => false
      t.string :datei

      t.timestamps
    end
  end
end
