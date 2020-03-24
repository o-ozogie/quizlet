Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  post '/user', to: 'users#create'

  post '/auth', to: 'auths#sign_in'
  patch '/auth', to: 'auths#refresh'

  get '/set/:set_id', to: 'question_sets#show'
  post '/set', to: 'question_sets#create'
  patch '/set/:set_id', to: 'question_sets#update'
  delete '/set/:set_id', to: 'question_sets#delete'

  get '/question/:question_id', to: 'questions#show'
  post '/question', to: 'questions#create'
  patch '/question/:question_id', to: 'questions#update'
  delete '/question/:question_id', to: 'questions#delete'

  get '/score/:question_id', to: 'scores#show'
  post '/score/:question_id', to: 'scores#create'
  patch '/score/:score_id', to: 'scores#update'
end
