Rails.application.routes.draw do
  root 'home#index'
  resources :clients
  resources :users do
    member do
      get 'download_pdf'
      post 'send_email_user'
    end
  end
  resources :items do
    member do
      get 'download_pdf'
    end
  end
  resources :home
  resources :invoices

  get 'items/get_rate' , to: 'items#get_rate'

  # get 'invoices/display'

end
