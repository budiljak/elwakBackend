class AddBeendetToSchichts < ActiveRecord::Migration
  def change
    add_column :schichts, :beendet, :boolean, null: false, default: true
    change_column_default :schichts, :beendet, false # So wird die Spalte für bestehende Daten auf 'true' gesetzt, aber dann ist der Default 'false'
    add_index :schichts, :beendet
  end
end
