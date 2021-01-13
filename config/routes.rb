Rails.application.routes.draw do
  root 'quiz#menu'
  get 'debug/index'
  get 'quiz/index'
  get 'quiz/start'
  get 'quiz/restart'
  post 'quiz/start'
  get 'quiz/answer'
  post 'quiz/answer'
  get 'quiz/menu'
  post 'quiz/menu'
end
