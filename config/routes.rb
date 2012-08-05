Socialnamegame::Application.routes.draw do
  resources :people

  match 'game(/:action(/:id))', controller: :game

  root :to => "home#index"
end
