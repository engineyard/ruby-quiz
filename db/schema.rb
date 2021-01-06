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

ActiveRecord::Schema.define(version: 20201028195546) do

  create_table "attempts", force: :cascade do |t|
    t.string "quiz_id"
    t.string "taker"
    t.integer "number_correct"
    t.integer "number_incorrect"
  end

  create_table "questions", force: :cascade do |t|
    t.string "quiz_id"
    t.integer "order"
    t.string "question"
    t.string "option_a"
    t.string "option_b"
    t.string "option_c"
    t.string "option_d"
    t.string "correct_answer"
  end

  create_table "quizzes", force: :cascade do |t|
    t.string "name"
  end

end
