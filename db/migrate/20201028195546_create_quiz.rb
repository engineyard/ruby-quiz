class CreateQuiz < ActiveRecord::Migration[5.1]
  def change
    create_table :quizzes do |t|
      t.string :name
    end
    create_table :questions do |t|
      t.string :quiz_id
      t.integer :order
      t.string :question
      t.string :option_a
      t.string :option_b
      t.string :option_c
      t.string :option_d
      t.string :correct_answer
    end
    create_table :attempts do |t|
      t.string :quiz_id
      t.string :taker
      t.integer :number_correct
      t.integer :number_incorrect
    end
  end
end
