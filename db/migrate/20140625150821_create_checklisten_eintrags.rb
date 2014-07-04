class CreateChecklistenEintrags < ActiveRecord::Migration
  def change
    create_table :checklisten_eintrags do |t|
      t.references :checklisten_vorlage, index: true
      t.string :bezeichner
      t.text :was
      t.text :wann
      t.integer :typ
      t.integer :position

      t.timestamps
    end
  end
end
