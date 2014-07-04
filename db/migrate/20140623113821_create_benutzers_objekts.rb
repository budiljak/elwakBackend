class CreateBenutzersObjekts < ActiveRecord::Migration
  def change
    create_table :benutzers_objekts, :id => false do |t|
      t.integer :benutzer_id
      t.integer :objekt_id
    end
    add_index :benutzers_objekts, :benutzer_id
    add_index :benutzers_objekts, :objekt_id
  end
end
