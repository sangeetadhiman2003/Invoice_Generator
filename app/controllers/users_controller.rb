require "prawn"
class UsersController < ApplicationController

  def index
    if params[:query].present?
      # filtered data
       @users = User.where("name LIKE ?", "%#{params[:query]}%")
    else
      # all data
      @users = User.all
    end

  end


  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
       flash[:notice] = "User was successfully created."
       redirect_to @user
    else
       render :new, status: :unprocessable_entity
    end
  end

  def show
    @user = User.find(params[:id])

    respond_to do |format|
      format.html
      format.pdf do
        pdf = render_to_string pdf: "#{@user.id}", template: 'users/show.html.erb', layout: 'pdf.html.erb'
        send_data pdf, filename: "#{@user.name}.pdf",type: 'application/pdf' , disposition: 'attachment'
      end
    end
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

  def duplicate
    original_user = User.find(params[:id])
    new_user = original_user.dup
    new_user.save

    redirect_to user_path, notice: 'Product duplicated successfully'
  end

  def restore
    @user = User.only_deleted.find(params[:id])
    @user.restore_id!

    redirect_to users_path, notice: 'User has been restored.'
  end

  def destroy
    @user = User.find(params[:id])
    @user.destroy

    redirect_to users_path, notice: 'User was moved to the recycle bin.'
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
      text "City: #{user.state}"
    end.render
  end
end
