class CreateChecklistenVorlages < ActiveRecord::Migration
  def change
    create_table :checklisten_vorlages do |t|
      t.references :objekt, index: true
      t.string :bezeichner
      t.integer :version, :null => false, :default => 1
      t.boolean :inaktiv

      t.timestamps
    end
  end
end
