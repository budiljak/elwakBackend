class CreateInfos < ActiveRecord::Migration
  def change
    create_table :infos do |t|
      t.references :benutzer, index: true
      t.integer :art
      t.datetime :datum_uhrzeit
      t.string :betreff
      t.text :text
      t.string :datei

      t.timestamps
    end
  end
end
