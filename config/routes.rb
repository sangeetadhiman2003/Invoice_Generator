Rails.application.routes.draw do

  devise_for :organizations

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  root 'home#index'


  resources :clients do
    member do
      get 'download_pdf'
      get 'details', to: 'clients#details'
    end
  end

  resources :users do
    member do
      get 'download_pdf'
      post 'send_email_user'
      get 'duplicate'
      delete 'soft_delete'
      post 'restore'
      delete 'delete_image'
      post 'generate_and_email_invoices'
    end
    collection do
      delete 'delete_selected'
      post 'share_email'
      post 'batch_action'
    end

  end

  resources :items do
    member do
      get 'download_pdf'
      get 'get_rate'
    end
  end

  resources :home
  resources :invoices do
    member do
      post 'duplicate'
    end
    collection do
      post 'generate_pdf'
      post 'batch_action'
      get 'preview'
    end
  end

  resources :products do
    member do
      get 'details', to: 'products#details'
    end
  end

end
