Socialnamegame::Application.routes.draw do

  match 'game(/:action(/:id))', controller: :game

  match "/auth/:provider/callback" => "sessions#create"

  match "/signout" => "sessions#destroy", :as => :signout

  match '/delete_account' => "home#delete_account", :as => :delete_account

  root :to => "home#index"
end
