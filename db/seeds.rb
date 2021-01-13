require 'quiz'
require 'question'
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: 'Star Wars' }, { name: 'Lord of the Rings' }])
#   Character.create(name: 'Luke', movie: movies.first)
Quiz.create(id: 1, name: 'The New Years Trivia Challenge')
Question.create(quiz_id: 1, order: 1,
      question: 'Which investment is shown in the graph?',
      option_a: 'Amazon',
      option_b: 'Bitcoin',
      option_c: 'Ethereum',
      option_d: 'Tesla',
      correct_answer: 'B'
)
Question.create(quiz_id: 1, order: 2,
      question: 'In the graph, how many paths connect node A to node B that never go up?',
      option_a: '24',
      option_b: '27',
      option_c: '35',
      option_d: '37',
      correct_answer: 'C'
)
Question.create(quiz_id: 1, order: 3,
      question: 'On average, humans blink 20 times per minute. How many times do they blink when looking at a computer?',
      option_a: '7',
      option_b: '12',
      option_c: '20',
      option_d: '23',
      correct_answer: 'A'
)
Question.create(quiz_id: 1, order: 4,
      question: 'Which planet in our solar system is shown here?',
      option_a: 'Jupiter',
      option_b: 'Mars',
      option_c: 'Mercury',
      option_d: 'Venus',
      correct_answer: 'A'
)
Question.create(quiz_id: 1, order: 5,
      question: 'Which city is shown here?',
      option_a: 'Boston, MA USA',
      option_b: 'Shenzen, China',
      option_c: 'Tokyo, Japan',
      option_d: 'Toronto, Canada',
      correct_answer: 'C'
)
