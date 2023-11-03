class ProductsController < ApplicationController

  def show

  end

  def details
    @product = Product.find(params[:id])
     render json: {
      name: @product.name,
      gst: @product.gst,
      tax_value: @product.tax_value,
      rate: @product.rate
    }

    # render json: @product.slice(:name, :rate, :tax_value, :gst)
  end
end
