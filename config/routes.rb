Debitos::Application.routes.draw do
  devise_for :users
  devise_scope :user do
    get '/login', to: "devise/cas_sessions#new"
    post '/logout', to: "devise/cas_sessions#destroy"
  end

  # resources :users do
    # Hacer que sea para cada usuario.
  #  collection { get :main }
  # end


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
    resources :presentations
    
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
  match '/help',    to: 'static_pages#help'
  match '/about',   to: 'static_pages#about'
  match '/contact', to: 'static_pages#contact'
  match '/news', to: 'static_pages#news'
  match '/visa_credito', to:'summaries#visa_cred'
  match '/visa_debito', to:'summaries#visa_deb'
  match '/master_credito', to:'summaries#master_cred'
  match '/master_debito', to:'summaries#master_deb'
  match '/american_express_credito', to:'summaries#amex_cred'
  match '/american_express_debito', to:'summaries#amex_deb'

end
