require 'combine_pdf'
class InvoicesController < ApplicationController

  def index
    if params[:query].present?
      # filtered data
       @invoices = Invoice.where("invoice_date LIKE ?", "%#{params[:query]}%")
    else
      # all data
      @invoices = Invoice.all
      @items = Item.all
      @clients = Client.all
      @users = User.all.sort_by { |user| [user.name.downcase, user.name] }

    end

  end

  def show
    @invoice = Invoice.find(params[:id])
    @items = @invoice.items

    respond_to do |format|
      format.html
      format.pdf do
        html_content = render_to_string(layout: 'layouts/pdf_layout', template: 'invoices/show.html.erb', locals: { invoice: @invoice })

      render pdf: 'invoice.pdf', layout: 'layouts/pdf_layout', content: html_content
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
    debugger
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


  def batch_action
    batch_action = params[:batch_action]
    selected_invoice_ids = params[:invoice_ids] || []

    case batch_action
      when 'delete'
        Invoice.where(id: selected_invoice_ids).destroy_all
        redirect_to invoices_path, notice: 'Selected invoices deleted.'
      when 'generate_pdf'
        selected_invoice_ids = params[:invoice_ids]
        selected_layout = params[:layout]
        invoices = Invoice.where(id: selected_invoice_ids)

        html_content = []

        invoices.each do |invoice|
          @invoice = invoice
          @items = @invoice.items
          html_content << render_to_string(layout: "pdf/#{selected_layout}.html.erb", template: 'invoices/show.html.erb', locals: { invoice: @invoice })
          html_content << "<p style='page-break-before: always'></p>"
        end

        combined_html = html_content.join("\n")

        PdfGeneratorJob.perform_async(selected_invoice_ids, combined_html, 'invoices/show.html.erb', selected_layout)

        pdf_data = WickedPdf.new.pdf_from_string(combined_html, page_size: 'A4')

        send_data pdf_data, type: "application/pdf", filename: "combined_invoices.pdf"

      else
        redirect_to invoices_path, alert: 'Invalid batch action.'
      end
  end



  private

  def invoice_params
    params.require(:invoice).permit(:id, :invoice_no , :invoice_date , :due_date , :user_id , :client_id , :terms_and_condition , :notes , :logo_image , items_attributes: [:id, :quantity, :amountPaid , :invoice_id, :product_id, :_destroy] )
  end

end
