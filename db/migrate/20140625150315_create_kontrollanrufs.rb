class CreateKontrollanrufs < ActiveRecord::Migration
  def change
    create_table :kontrollanrufs do |t|
      t.references :wachbuch_eintrag, index: true
      t.string :uhrzeit
      t.string :objekt
      t.text :bemerkung
      t.integer :position

      t.timestamps
    end
  end
end
