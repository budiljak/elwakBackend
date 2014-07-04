class CreateBenutzers < ActiveRecord::Migration
  def change
    create_table :benutzers do |t|
      t.string :login
      t.string :passwort
      t.string :vorname
      t.string :nachname
      t.integer :typ
      t.boolean :inaktiv, :null => false, :default => false

      t.timestamps
    end
    add_index :benutzers, :login
  end
end
