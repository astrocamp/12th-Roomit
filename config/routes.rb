Rails.application.routes.draw do
  root "rooms#index"
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  devise_for :users, controllers: { sessions: "users/sessions", omniauth_callbacks: "users/omniauth_callbacks", passwords: "users/passwords", registrations: "users/registrations", confirmations: "users/confirmations", mailer: "users/mailer", unlocks: "users/unlocks" }
  # root "room#home"
  resources :rooms do
    collection do
      get :card
    end
  end
end
