class InvoicesController < ApplicationController

  def index
    @invoices = Invoice.all
    @items = Item.all
    @clients = Client.all
    @users = User.all.sort_by { |user| [user.name.downcase, user.name] }
  end

  def show
    @invoice = Invoice.find(params[:id])
    @items = @invoice.items

    total_value = @invoice.calculate_total_tax


    respond_to do |format|
      format.html
      format.pdf do
        pdf = render_to_string pdf: "#{@invoice.id}", template: 'invoices/show.html.erb', layout: 'pdf.html.erb'
        send_data pdf, filename: "#{@invoice.invoice_no}.pdf",type: 'application/pdf' , disposition: 'attachment'
      end
    end
  end

  def new
    @users = User.all
    @clients = Client.all
    @products = Product.all
    @invoice = Invoice.new
    @invoice.items.build
  end

  def create
    @invoice = Invoice.new(invoice_params)
    if @invoice.save
      redirect_to @invoice.user
    else
      @users=User.all
      @clients = Client.all
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @invoice = Invoice.find(params[:id])
    @users = User.all
    @product = Product.all
    @clients = Client.all
  end

  def update
    @invoice = Invoice.find(params[:id])

    if @invoice.update(invoice_params)
      redirect_to @invoice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    original_invoice = Invoice.find(params[:id])
    new_invoice = original_invoice.dup
    new_invoice.save

    redirect_to invoice_path, notice: 'Product duplicated successfully'
  end

  def destroy
    @invoice = Invoice.find(params[:id])
    @invoice.destroy

    redirect_to invoices_path, status: :see_other
  end

  def calculate_total
    subtotal = product.rate
    total_tax = product.tax_value + (product.rate * (product.gst)/100)
    subtotal + total_tax
  end

  private

  def invoice_params
    params.require(:invoice).permit(:id, :invoice_no , :invoice_date , :due_date , :user_id , :client_id , :terms_and_condition , :notes , :logo_image , items_attributes: [:id, :quantity, :amountPaid , :invoice_id, :product_id, :_destroy] )
  end
end
