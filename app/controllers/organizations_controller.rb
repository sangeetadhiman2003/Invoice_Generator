class OrganizationsController < ApplicationController
  before_action :set_organization

  def index
    @organizations = Organization.all
    @bank_names = @organizations.map { |organization| organization.bank_accounts.pluck(:name) }
    #render json: @organizations, each_serializer: OrganizationSerializer

  end

  def select_bank_account
    selected_bank_account_id = params[:bank_account]
    session[:selected_bank_account_id] = selected_bank_account_id
  end

  private

  def set_organization
    @organization = current_organization
  end

end
