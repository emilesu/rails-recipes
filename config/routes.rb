Rails.application.routes.draw do

  devise_for :users

  resources :events

  namespace :admin do
    root "events#index"
    resources :events do
      resources :tickets, :controller => "event_tickets"

        collection do
          post :bulk_update
        end
    end
    resources :users do
      resource :profile, :controller => "user_profiles"
    end
  end

  get "/faq" => "pages#faq"

  resource :user                  #单数resource路由，少了index，网址不会有ID，路由方法不需要参数

  root "events#index"

end
