class InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
  end

  def show
    @invoice = Invoice.find(params[:id])
  end

  def new
    @users=User.all
    @invoice = Invoice.new
    @invoice.items.build
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      redirect_to @invoice.user
    else
      @users=User.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @users = User.all
    @invoice = Invoice.find(params[:id])
  end

  def update
    @invoice = Invoice.find(params[:id])

    if @invoice.update(invoice_params)
      redirect_to @invoice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def invoice_params
    params.require(:invoice).permit(:invoice_no , :invoice_date , :due_date ,
     :user_id , :terms_and_condition , :notes , :logo_image , items_attributes:[:name , :rate , :quantity , :hours , :gst , :tax_value ,:invoice_id] )
  end
end
