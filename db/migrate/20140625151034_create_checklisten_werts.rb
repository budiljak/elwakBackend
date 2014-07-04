class CreateChecklistenWerts < ActiveRecord::Migration
  def change
    create_table :checklisten_werts do |t|
      t.references :checkliste, index: true
      t.references :checklisten_eintrag, index: true
      t.string :inhalt

      t.timestamps
    end
  end
end
