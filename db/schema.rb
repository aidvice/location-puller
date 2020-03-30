# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `rails
# db:schema:load`. When creating a new database, `rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 2020_03_28_161149) do

  create_table "city_cases", force: :cascade do |t|
    t.string "state_short_name"
    t.string "city_name"
    t.integer "confirmed_cases"
    t.integer "suspicious_cases"
    t.integer "no_of_deaths"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

  create_table "state_cases", force: :cascade do |t|
    t.string "state_long_name"
    t.string "state_short_name"
    t.integer "confirmed_cases"
    t.integer "suspicious_cases"
    t.integer "no_of_deaths"
    t.datetime "created_at", precision: 6, null: false
    t.datetime "updated_at", precision: 6, null: false
  end

end
