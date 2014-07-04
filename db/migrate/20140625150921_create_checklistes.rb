class CreateChecklistes < ActiveRecord::Migration
  def change
    create_table :checklistes do |t|
      t.references :checklisten_vorlage, index: true
      t.references :schicht, index: true
      t.string :uhrzeit
      t.integer :position

      t.timestamps
    end
  end
end
