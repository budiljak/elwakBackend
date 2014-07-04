class CreateSchichts < ActiveRecord::Migration
  def change
    create_table :schichts do |t|
      t.references :objekt, index: true
      t.references :benutzer, index: true
      t.datetime :datum
      t.string :uhrzeit_beginn
      t.string :uhrzeit_ende

      t.timestamps
    end
  end
end
