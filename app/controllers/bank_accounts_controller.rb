class BankAccountsController < ApplicationController

  def index
    @bank_accounts = BankAccount.where(organization_id: current_organization.id)
  end

  def new
    @bank_account = BankAccount.new
  end

  def create
    @bank_account =current_organization.bank_accounts.new(bank_account_params)
    if @bank_account.save
       flash[:notice] = "Account was successfully created."
       redirect_to @bank_account
    else
      render :new, status: :unprocessable_entity
    end
  end

  def show
    @bank_account = BankAccount.find(params[:id])
  end

  def bank_account_params
    params.require(:bank_account).permit(:name, :account_number, :ifsc_code, :organization_id)
  end

end
