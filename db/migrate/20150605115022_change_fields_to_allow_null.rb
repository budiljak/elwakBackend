class ChangeFieldsToAllowNull < ActiveRecord::Migration
  def change
    change_column_null(:wachbuch_eintrags, :ausruestung_vollzaehlig, true)
    change_column_default(:wachbuch_eintrags, :ausruestung_vollzaehlig, nil)
    change_column_null(:wachbuch_eintrags, :ausruestung_funktion, true)
    change_column_default(:wachbuch_eintrags, :ausruestung_funktion, nil)
    change_column_null(:wachbuch_eintrags, :schluessel_vollzaehlig, true)
    change_column_default(:wachbuch_eintrags, :schluessel_vollzaehlig, nil)
  end
end
