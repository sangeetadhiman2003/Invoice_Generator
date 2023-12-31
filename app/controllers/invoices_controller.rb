require 'combine_pdf'
class InvoicesController < ApplicationController
  before_action :set_organization
  before_action :set_invoice, only: [:show, :edit, :update, :destroy]
  before_action :set_organization_and_invoice_type
  before_action :load_invoice_from_session, only: [:new]

  def index
    if params[:query].present?
      # filtered data
      @invoices = Invoice.where("invoice_date LIKE ?", "%#{params[:query]}%")
    else
      # all data
      @invoices = Invoice.joins(user: :organization).where(organizations: { id: @organization.id })
      @items = Item.all
      @clients = Client.joins(user: :organization).where(organizations: { id: @organization.id })
      @users = User.where(organization_id: current_organization.id).sort_by { |user| [user.name.downcase, user.name] }
    end

  end

  def show
    #@invoice = Invoice.find(params[:id])
    @items = @invoice.items
    @services = @invoice.services
    respond_to do |format|
      format.html
      format.pdf do
        html_content = render_to_string(layout: 'pdf.html.erb', template: 'invoices/show.html.erb', locals: { invoice: @invoice })

        render pdf: 'invoice.pdf', layout: 'pdf.html.erb', content: html_content
      end
    end
  end

  def new
    #@users = User.where(organization_id: current_organization.id)
    @users = @organization.users
    @clients = Client.joins(user: :organization).where(organizations: { id: @organization.id })
    @products = Product.all
    @invoice = Invoice.new(session[:invoice_params])
    session[:invoice_params] = nil
    @invoice.services.build
    @invoice.items.build
    @invoice.invoice_no = Invoice.next_invoice_number
 end

  def create
    if params[:reset]
      clear_invoice_params_in_session
      redirect_to new_invoice_path
    else
      @invoice = Invoice.new(invoice_params)
      debugger
      if params[:preview_button]
        store_invoice_params_in_session
        render :preview
      elsif @invoice.save
        clear_invoice_params_in_session
        redirect_to @invoice, notice: 'Invoice was successfully created.'
      else
        render :new
      end
    end
  end

  def edit
    # @invoice = Invoice.find(params[:id])
    @users = User.all
    @product = Product.all
    @clients = Client.all
  end

  def update
    #@invoice = Invoice.find(params[:id])
    if @invoice.update(invoice_params)
      redirect_to @invoice
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def duplicate
    original_invoice = @invoice
    new_invoice = original_invoice.dup
    new_invoice.save

    redirect_to invoice_path, notice: 'Product duplicated successfully'
  end

  def destroy
    #@invoice = Invoice.find(params[:id])
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

  # def preview
  #   @invoice = Invoice.new(session[:invoice_params])
  #   render :preview
  # end

  def preview
    @invoice = Invoice.new(session[:invoice_params])

    respond_to do |format|
      format.html
      format.js { render layout: false }
    end
    render layout: false
  end

  private

  def invoice_params
    params.require(:invoice).permit(:id, :invoice_no, :invoice_date, :due_date, :user_id, :client_id, :terms_and_condition, :notes, :logo_image, items_attributes: [:id, :quantity, :amountPaid, :invoice_id, :product_id, :_destroy], services_attributes: [:name, :hour, :amount, :_destroy])
  end

  def set_organization
    @organization = current_organization
  end

  def set_organization_and_invoice_type
    #@organization = current_organization if organization_signed_in?
    @invoice_type = 'PRODUCT'
  end

  def set_invoice
    @invoice = Invoice.find(params[:id])
  end

  def load_invoice_from_session
    @invoice = Invoice.new(session[:invoice_params])
  end

  def store_invoice_params_in_session
    session[:invoice_params] = invoice_params
  end

  def clear_invoice_params_in_session
    session[:invoice_params] = nil
  end

end
