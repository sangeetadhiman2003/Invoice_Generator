Rails.application.routes.draw do
  root 'home#index'

  resources :clients do
    member do
      get 'download_pdf'
    end
  end

  resources :users do
    member do
      get 'download_pdf'
      post 'send_email_user'
      post 'duplicate'
      delete 'soft_delete'
      post 'restore'
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
  end

  resources :products do
    member do
      get 'details', to: 'products#details'
    end
  end
end
