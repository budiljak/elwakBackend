class CreateInfoEmpfaengers < ActiveRecord::Migration
  def change
    create_table :info_empfaengers do |t|
      t.references :info, index: true
      t.references :benutzer, index: true
      t.boolean :gelesen, :null => false, :default => false

      t.timestamps
    end
  end
end
