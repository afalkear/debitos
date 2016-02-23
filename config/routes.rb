Debitos::Application.routes.draw do
  namespace :admin do
    #resources :users
    #resources :accounts
    #resources :card_companies
    #resources :contacts
    #resources :google_users
    #resources :presentations
    #resources :responsibles
    #root to: "users#index"
  end

  devise_for :users
  devise_scope :user do
    get '/login', to: "devise/cas_sessions#new"
    post '/logout', to: "devise/cas_sessions#destroy"
  end

  # resources :users do
    # Hacer que sea para cada usuario.
  #  collection { get :main }
  # end


  resources :presentations
  resources :accounts do
    resources :contacts do
      collection { get :plans }
      collection { post :import }
      collection { post :edit_multiple}
      collection { post :update_multiple}
      collection { post :delete_multiple}
      collection { post :set_multiple_inactive}
      collection { get :synch_with_contacts }
    end

    resources :card_companies do
      resources :presentations
    end
  end
  resources :responsibles
  resources :card_companies

  # resources :sessions, only: [:new, :create, :destroy]
  resources :summaries do
    collection {get "download"}
  end
  resources :google_users, only: [:new, :create, :destroy]

  root to: 'accounts#index'

  # match '/signup',  to: 'users#new'
  # match '/signin', to: 'sessions#new'
  # match '/signout', to: 'sessions#destroy', via: :delete
  get '/help',    to: 'static_pages#help'
  get '/about',   to: 'static_pages#about'
  get '/contact', to: 'static_pages#contact'
  get '/news', to: 'static_pages#news'
  get '/visa_credito', to:'summaries#visa_cred'
  get '/visa_debito', to:'summaries#visa_deb'
  get '/master_credito', to:'summaries#master_cred'
  get '/master_debito', to:'summaries#master_deb'
  get '/american_express_credito', to:'summaries#amex_cred'
  get '/american_express_debito', to:'summaries#amex_deb'

end
