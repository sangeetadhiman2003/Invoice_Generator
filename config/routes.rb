Rails.application.routes.draw do

  root 'home#index'

  devise_for :organizations,  controllers: { registrations: 'registrations' }

  require 'sidekiq/web'
  mount Sidekiq::Web => '/sidekiq'

  resources :organizations do
    member do
      post 'select_bank_account'
    end
  end
  resources :bank_accounts
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
      get 'generate_doc', format: [:html, :docx]
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

  post '/payments/create', to: 'payments#create'


end
