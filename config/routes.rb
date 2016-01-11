Rails.application.routes.draw do
  mount Bootsy::Engine => '/bootsy', as: 'bootsy'
  devise_for :users
  
  root 'dashboard#index'

  get 'dashboard/csv_management'
  get 'dashboard/export_user_email'
  get 'dashboard/export_user_data'
  get 'dashboard/export_full_db_data'
  get 'dashboard/contact_us'
  get 'dashboard/qui_sommes_nous'
  post 'dashboard/import_user_info'
  resources :users do
    get :autocomplete_user_nom, on: :collection
    collection do
      get 'get_search_info'
      get 'user_menu'
      get 'search_philanthropotes'
      get 'change_password'
      post 'send_contact_mail'
      patch 'update_password'
    end
  end    

  resources :posts do
    resources :comments 
    member do
      get 'posts_for_category'
    end
  end 

  resources :notifications do
    collection do
      get 'main_announcement'
    end  
  end  


end
