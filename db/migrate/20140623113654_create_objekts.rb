class CreateObjekts < ActiveRecord::Migration
  def change
    create_table :objekts do |t|
      t.string :bezeichner
      t.boolean :inaktiv, :null => false, :default => false

      t.timestamps
    end
  end
end
