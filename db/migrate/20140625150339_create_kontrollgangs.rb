class CreateKontrollgangs < ActiveRecord::Migration
  def change
    create_table :kontrollgangs do |t|
      t.references :wachbuch_eintrag, index: true
      t.string :uhrzeit
      t.text :bemerkung
      t.integer :position

      t.timestamps
    end
  end
end
