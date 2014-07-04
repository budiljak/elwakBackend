class ObjektZuordnungs < ActiveRecord::Migration
  def change
    create_table :objekt_zuordnungs do |t|
      t.integer :benutzer_id
      t.index :benutzer_id
      t.integer :objekt_id
      t.index :objekt_id

      t.timestamps
    end
  end
end
