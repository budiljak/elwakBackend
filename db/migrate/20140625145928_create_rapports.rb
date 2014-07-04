class CreateRapports < ActiveRecord::Migration
  def change
    create_table :rapports do |t|
      t.references :schicht, index: true
      t.text :beschreibung
      t.text :ort
      t.string :uhrzeit
      t.text :massnahmen
      t.integer :position

      t.timestamps
    end
  end
end
