# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20150611125630) do

  create_table "benutzers", force: true do |t|
    t.string   "login"
    t.string   "passwort"
    t.string   "vorname"
    t.string   "nachname"
    t.integer  "typ"
    t.boolean  "inaktiv",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "benutzers", ["login"], name: "index_benutzers_on_login"

  create_table "benutzers_objekts", id: false, force: true do |t|
    t.integer "benutzer_id"
    t.integer "objekt_id"
  end

  add_index "benutzers_objekts", ["benutzer_id"], name: "index_benutzers_objekts_on_benutzer_id"
  add_index "benutzers_objekts", ["objekt_id"], name: "index_benutzers_objekts_on_objekt_id"

  create_table "checklisten_eintrags", force: true do |t|
    t.integer  "checklisten_vorlage_id"
    t.string   "bezeichner"
    t.text     "was"
    t.text     "wann"
    t.integer  "typ"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklisten_eintrags", ["checklisten_vorlage_id"], name: "index_checklisten_eintrags_on_checklisten_vorlage_id"

  create_table "checklisten_vorlages", force: true do |t|
    t.integer  "objekt_id"
    t.string   "bezeichner"
    t.integer  "version",    default: 1,     null: false
    t.boolean  "inaktiv",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklisten_vorlages", ["objekt_id"], name: "index_checklisten_vorlages_on_objekt_id"

  create_table "checklisten_werts", force: true do |t|
    t.integer  "checkliste_id"
    t.integer  "checklisten_eintrag_id"
    t.string   "inhalt"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklisten_werts", ["checkliste_id"], name: "index_checklisten_werts_on_checkliste_id"
  add_index "checklisten_werts", ["checklisten_eintrag_id"], name: "index_checklisten_werts_on_checklisten_eintrag_id"

  create_table "checklistes", force: true do |t|
    t.integer  "checklisten_vorlage_id"
    t.integer  "schicht_id"
    t.string   "uhrzeit"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "checklistes", ["checklisten_vorlage_id"], name: "index_checklistes_on_checklisten_vorlage_id"
  add_index "checklistes", ["schicht_id"], name: "index_checklistes_on_schicht_id"

  create_table "info_empfaengers", force: true do |t|
    t.integer  "info_id"
    t.integer  "benutzer_id"
    t.boolean  "gelesen",     default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "info_empfaengers", ["benutzer_id"], name: "index_info_empfaengers_on_benutzer_id"
  add_index "info_empfaengers", ["info_id"], name: "index_info_empfaengers_on_info_id"

  create_table "infos", force: true do |t|
    t.integer  "benutzer_id"
    t.integer  "art"
    t.datetime "datum_uhrzeit"
    t.string   "betreff"
    t.text     "text"
    t.string   "datei"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "infos", ["benutzer_id"], name: "index_infos_on_benutzer_id"

  create_table "kontrollanrufs", force: true do |t|
    t.integer  "wachbuch_eintrag_id"
    t.string   "uhrzeit"
    t.string   "objekt"
    t.text     "bemerkung"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kontrollanrufs", ["wachbuch_eintrag_id"], name: "index_kontrollanrufs_on_wachbuch_eintrag_id"

  create_table "kontrollgangs", force: true do |t|
    t.integer  "wachbuch_eintrag_id"
    t.string   "uhrzeit"
    t.text     "bemerkung"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "kontrollgangs", ["wachbuch_eintrag_id"], name: "index_kontrollgangs_on_wachbuch_eintrag_id"

  create_table "objekt_zuordnungs", force: true do |t|
    t.integer  "benutzer_id"
    t.integer  "objekt_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "objekt_zuordnungs", ["benutzer_id"], name: "index_objekt_zuordnungs_on_benutzer_id"
  add_index "objekt_zuordnungs", ["objekt_id"], name: "index_objekt_zuordnungs_on_objekt_id"

  create_table "objekts", force: true do |t|
    t.string   "bezeichner"
    t.boolean  "inaktiv",    default: false, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pdf_dateis", force: true do |t|
    t.integer  "objekt_id"
    t.integer  "art"
    t.string   "name"
    t.boolean  "geloescht",  default: false, null: false
    t.string   "datei"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "pdf_dateis", ["objekt_id"], name: "index_pdf_dateis_on_objekt_id"

  create_table "rapports", force: true do |t|
    t.integer  "schicht_id"
    t.text     "beschreibung"
    t.text     "ort"
    t.string   "uhrzeit"
    t.text     "massnahmen"
    t.integer  "position"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "rapports", ["schicht_id"], name: "index_rapports_on_schicht_id"

  create_table "schichts", force: true do |t|
    t.integer  "objekt_id"
    t.integer  "benutzer_id"
    t.datetime "datum"
    t.string   "uhrzeit_beginn"
    t.string   "uhrzeit_ende"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "beendet",        default: false, null: false
  end

  add_index "schichts", ["beendet"], name: "index_schichts_on_beendet"
  add_index "schichts", ["benutzer_id"], name: "index_schichts_on_benutzer_id"
  add_index "schichts", ["objekt_id"], name: "index_schichts_on_objekt_id"

  create_table "wachbuch_eintrags", force: true do |t|
    t.integer  "schicht_id"
    t.text     "besonderheiten"
    t.text     "schaeden"
    t.boolean  "ausruestung_vollzaehlig"
    t.boolean  "ausruestung_funktion"
    t.boolean  "schluessel_vollzaehlig"
    t.string   "schluessel_bemerkung"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "wachbuch_eintrags", ["schicht_id"], name: "index_wachbuch_eintrags_on_schicht_id"

end
