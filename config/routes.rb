Socialnamegame::Application.routes.draw do
  resources :people

  match 'game(/:action(/:id))', controller: :game

  match "/auth/:provider/callback" => "sessions#create"

  match "/signout" => "sessions#destroy", :as => :signout

  root :to => "home#index"
end
