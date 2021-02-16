require_relative '../helpers/application_helper'
require 'set'
require 'prime'

class QuizController < ApplicationController

  include ApplicationHelper

  def load_data
    @quiz = Quiz.find(1)
    @questions = Question.where(quiz_id: @quiz.id).to_a
    if params["attempt"]
        puts "Attempt params"
        puts params["attempt"]
        local_attempt = Attempt.new(attempt_params)
        puts "Now getting from database"
        @attempt = Attempt.find_by(taker: local_attempt.taker)
        if @attempt
            puts "The database version is this: #{@attempt}" 
            @attempt.answer = local_attempt.answer
            @attempt.current_question_number = local_attempt.current_question_number
        else 
            puts "Not in the database yet"
            @attempt = local_attempt
        end
    else
        @attempt = Attempt.new
        @attempt.phase = "begin"
    end
  end

  def index
    load_data
  end

  def menu
    load_data
  end

  def start
    load_data
    @question_number = 0
    @attempt.quiz_id = @quiz.id
    @attempt.number_correct = 0
    @attempt.number_incorrect = 0
    @attempt.current_question_number = 1
    puts "The quiz taker is #{@attempt.taker}"
    if @attempt.taker.nil?
        @message = "You must provide a name."
        @attempt.phase = "begin"
    elsif @attempt.taker.length == 0
        @message = "You must provide a name."
        @attempt.phase = "begin"
    else
        @attempt.phase = "name"
    end
    puts "Saving the attempt in the database..."
    @attempt.save
    render :template => "quiz/index"
  end

  def attempt_params
    params.require(:attempt).permit(:taker, :quiz_id, :number_correct, :answer, :phase, :current_question_number)
  end

  def restart
    puts "In controller restart"
    load_data
    render :template => "quiz/menu"
  end

  def answer
    puts "In controller answer"
    load_data

    current_question = @questions[@attempt.current_question_number.to_i - 1]
    correct_answer_text = "" 
    if current_question.correct_answer == "A"
        correct_answer_text = current_question.option_a
    elsif current_question.correct_answer == "B"
        correct_answer_text = current_question.option_b
    elsif current_question.correct_answer == "C"
        correct_answer_text = current_question.option_c
    elsif current_question.correct_answer == "D"
        correct_answer_text = current_question.option_d
    end

    # Check if the answer was correct
    if @attempt.answer == current_question.correct_answer
        @message = "Correct! The answer was #{@attempt.answer}: #{correct_answer_text}"
        if @attempt.number_correct.nil?
            @attempt.number_correct = 1
        else
            @attempt.number_correct = @attempt.number_correct + 1
        end
    else 
        if @attempt.number_incorrect.nil?
            @attempt.number_incorrect = 1
        else
            @attempt.number_incorrect = @attempt.number_incorrect + 1
        end
        @message = "Sorry, the correct answer was #{current_question.correct_answer}: #{correct_answer_text}"
    end
    puts "Total questions: #{@questions.size}. We are on question #{@attempt.current_question_number.to_i}"
    puts "The correct answer was #{current_question.correct_answer}. User chose #{@attempt.answer}."
    puts "Current number correct: #{@attempt.number_correct}"

    @attempt.current_question_number = @attempt.current_question_number.to_i + 1
    #@attempt.update(number_correct: @attempt.number_correct, number_incorrect: @attempt.number_incorrect)
    @attempt.save
    render :template => "quiz/index"
  end

  def summary
      logger.info "In summary service"
      sum_of_correct_answers = 0
      high_score = 0
      attempts = Attempt.all
      attempts.each do |attempt|
        # Maintain the sum so we can calculate the average later
        sum_of_correct_answers = sum_of_correct_answers + attempt.number_correct
        # Check if this is the new high score
        if attempt.number_correct > high_score
              high_score = attempt.number_correct 
          end 
      end 

      prime_count = 0
      Prime.each(5000) do |prime|
          prime_count = prime_count + 1
          if prime_count % 20 == 0
              logger.info "Found a prime number: #{prime}"
          end 
      end

      response = {}
      response["number_of_participants"] = attempts.size
      response["average_score"] = (sum_of_correct_answers.to_f / attempts.size.to_f).round(2)
      response["high_score"] = high_score
      render :json => JSON[response]
  end 

  def participants 
    response = {}
    response["participants"] = Attempt.all.map { |attempt| attempt.taker }
    render :json => JSON[response]
  end
end
