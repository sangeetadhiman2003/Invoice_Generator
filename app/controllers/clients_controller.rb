require "prawn"
class ClientsController < ApplicationController
  before_action :set_organization
  before_action :set_client, only: %i[ show edit update destroy details ]

  def index
    # @clients = Client.all.sort_by { |client| [client.name.downcase, client.name] }
    @clients = Client.joins(user: :organization).where(organizations: { id: @organization.id })
    @users = User.where(organization_id: current_organization.id)

  end

  def show
    #@client = Client.find(params[:id])
    respond_to do |format|
      format.html
      format.pdf { render pdf: generate_pdf(@user) }
    end
  end

  def download_pdf
    #client = Client.find(params[:id])
    send_data generate_pdf(client),
    filename: "#{client.name}.pdf",
    type: "application/pdf"
  end

  def new
    @client = Client.new
    @users = User.where(organization_id: current_organization.id)
  end

  def create
    @client = Client.new(client_params)

    if @client.save
      redirect_to @client
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    #@client = Client.find(params[:id])
  end

  def update
    #@client = Client.find(params[:id])
    if @client.update(client_params)
      redirect_to @client
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    #@client = Client.find(params[:id])
    @client.destroy

    redirect_to root_path, status: :see_other
  end

  def details
    #@client = Client.find(params[:id])
    render json: {
      name: @client.name,
      address: @client.address,
      pan: @client.pan,
      phone: @client.phone,
      state: @client.state
    }
    # render json: @product.slice(:name, :rate, :tax_value, :gst)
  end

  private

  def client_params
    params.require(:client).permit(:name, :email, :address, :state,:signature_image, :city, :pan, :user_id)
  end

  def set_organization
    @organization = current_organization
  end

  def set_client
    @client = Client.find(params[:id])
  end

end
