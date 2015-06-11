class ChangeNullAndDefaultForInaktivField < ActiveRecord::Migration
  def change
    change_column_default :checklisten_vorlages, :inaktiv, false
    change_column_null :checklisten_vorlages, :inaktiv, false, false
  end
end
