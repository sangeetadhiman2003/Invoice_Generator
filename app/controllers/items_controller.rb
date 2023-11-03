require 'pagy'
class ItemsController < ApplicationController
  def index
    if params[:product_name].present?
      search_word = params[:product_name]
      if search_word
        @items = Item.joins(:product).where("products.name LIKE ?", "%#{search_word}%")
      else
        @items = Item.none
      end

    else
      @items = Item.all
    end

    @pagy, @items = pagy(@items)
  end


  def show
    @item = Item.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = render_to_string pdf: "#{@item.id}", template: 'items/show.html.erb', layout: 'pdf.html.erb'
        send_data pdf, filename: "#{@item.id}.pdf",type: 'application/pdf' , disposition: 'attachment'
      end
    end
  end

  def new
    @item = Item.new
    @product = Product.all
    @invoices = Invoice.all
    @invoice_id=Invoice.all.pluck(:invoice_id)
  end

  def create
    @item = Item.new(item_params)

    if @item.save
      redirect_to @item
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    @item = Item.find(params[:id])

    if @item.update(item_params)
      redirect_to @item
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @item = Item.find(params[:id])
    @item.destroy

    redirect_to root_path, status: :see_other
  end

  def get_rate
    item_name = params[:name]
    item = Item.find_by(name: item_name)

    if item
      render json: {rate: item.rate }
    else
      render json: {rate: nil }
    end
  end

  def get_rate
    item = Item.find(params[:id])
    render json: {rate: item.rate }
  end

  def get_rate
  end

  private
  def item_params
    params.require(:item).permit(:name, :rate, :quantity, :tax_value, :amountPaid, :gst, :invoice_id)
  end

  def generate_pdf(item)
    Prawn::Document.new do
      text item.name, align: :center
      text "Name: #{item.name}"
      text "Rate: #{item.rate}"
      text "Quantity: #{item.quantity}"
    end.render
  end
end
