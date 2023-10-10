class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception

  def submit
    byebug
    types = %w(invoices, users, clients)
    for type in types do
      type.constantize.save_attributes()
    end
  end
end
