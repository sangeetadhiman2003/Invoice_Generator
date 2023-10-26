class ApplicationController < ActionController::Base
  include Pagy::Backend
  protect_from_forgery with: :exception

  def submit
    types = %w(invoices, users, clients)
    for type in types do
      type.constantize.save_attributes()
    end
  end
end
