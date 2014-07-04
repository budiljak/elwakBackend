class CreateWachbuchEintrags < ActiveRecord::Migration
  def change
    create_table :wachbuch_eintrags do |t|
      t.references :schicht, index: true
      t.text :besonderheiten
      t.text :schaeden
      t.boolean :ausruestung_vollzaehlig, :null => false, :default => false
      t.boolean :ausruestung_funktion, :null => false, :default => false
      t.boolean :schluessel_vollzaehlig, :null => false, :default => false
      t.string :schluessel_bemerkung

      t.timestamps
    end
  end
end
