require "prawn"
class UsersController < ApplicationController
  def index
    @users = User.all
  end

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
       redirect_to @user
    else
       render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf { render pdf: generate_pdf(@user) }
    end
  end

  def download_pdf
    user = User.find(params[:id])
    send_data generate_pdf(user),
    filename: "#{user.name}.pdf",
    type: "application/pdf"
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])

    if @user.update(user_params)
      redirect_to @user
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to root_path, status: :see_other
  end

  def send_email_user
    @user = User.find(params[:id])
    @subject = "Greeting"
    @message = "Welcome..!"

    OrderMailer.send_email(@user, @subject, @message).deliver_now
    redirect_to root_path, notice: "Email send successfully"
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :state, :city, :gstin, :pan, :phone, :signature_image)
  end

  def generate_pdf(user)
    Prawn::Document.new do
      text user.name, align: :center
      text "Address: #{user.address}"
      text "Email: #{user.email}"
      text "City: #{user.city}"
    end.render
  end
end
