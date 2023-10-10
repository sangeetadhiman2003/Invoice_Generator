class ItemsController < ApplicationController
  def index
    @items=Item.all
  end

  def show
    @item = Item.find(params[:id])
  end


  def new
    @item = Item.new
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

  def download_pdf
    item = Item.find(params[:id])
    send_data generate_pdf(item),
    filename: "#{item.name}.pdf",
    type: "application/pdf"
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

  private
  def item_params
    params.require(:item).permit(:name, :rate, :quantity, :tax_value, :hours, :gst, :invoice_id)
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
