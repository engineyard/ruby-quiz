require_relative '../helpers/application_helper'
require 'set'

class QuizController < ApplicationController

  include ApplicationHelper

  def load_data
    @quiz = Quiz.find(1)
    @questions = Question.where(quiz_id: @quiz.id).to_a
    if params["attempt"]
        @attempt = Attempt.new(attempt_params)
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
        @message = "Sorry, the correct answer was #{current_question.correct_answer}: #{correct_answer_text}"
    end
    puts "Total questions: #{@questions.size}. We are on question #{@attempt.current_question_number.to_i}"
    puts "The correct answer was #{current_question.correct_answer}. User chose #{@attempt.answer}."
    puts "Current number correct: #{@attempt.number_correct}"

    @attempt.current_question_number = @attempt.current_question_number.to_i + 1
    render :template => "quiz/index"
  end
end
