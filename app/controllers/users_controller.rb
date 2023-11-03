require "prawn"
class UsersController < ApplicationController

  def index
    if params[:query].present?
      # filtered data
       @users = User.where("name LIKE ?", "%#{params[:query]}%")
    else
      # all data
      @users = User.all.sort_by { |user| [user.name.downcase, user.name] }
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

    if new_user.save
      redirect_to new_user, notice: 'User duplicated successfully'
    else
      redirect_to new_user, notice: 'User not duplicated successfully'
    end

  end

  def restore
    @user = User.only_deleted.find(params[:id])
    @user.restore_id!

    if @user.restore_id!
      redirect_to users_path, notice: 'User has been restored.'
    else
    redirect_to users_path, notice: 'User has not been restored.'
    end

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

    OrderMailer.send_email(@user).deliver_now
    redirect_to user_path(@user), notice: "Email send successfully"
  end

  def share_email
    selected_user_ids = params[:user_ids] || []
    selected_users = User.where(id: selected_user_ids)

    # Your logic to send an email to the selected users
    selected_users.each do |user|
      OrderMailer.send_email(user).deliver_now
    end

    redirect_to users_path, notice: 'Email shared with selected users.'
  end

  def delete_image
    user = User.find(params[:id])

    begin
      user.signature_image.purge  # Assuming "avatar" is the name of the attachment.
      flash[:notice] = "Image deleted successfully."
    rescue => e
      flash[:notice] = "Failed to delete the image: #{e.message}"
    end

    redirect_to user_path(user)  # Redirect to the user's profile or wherever is appropriate.
  end

  def delete_selected
    selected_user_ids = params[:user_ids] || []
    User.where(id: selected_user_ids).destroy_all
    redirect_to users_path, notice: 'Selected users deleted.'
  end

  def batch_action
    batch_action = params[:batch_action]
    selected_user_ids = params[:user_ids] || []

    case batch_action
    when 'delete'
      User.where(id: selected_user_ids).destroy_all
      redirect_to users_path, notice: 'Selected users deleted.'
    when 'share_email'
      selected_users = User.where(id: selected_user_ids)
      # Your logic to send an email to the selected users
      selected_users.each do |user|
        OrderMailer.send_email(user).deliver_now
      end
      redirect_to users_path, notice: 'Email shared with selected users.'
    else
      # Handle unsupported batch actions
      redirect_to users_path, alert: 'Invalid batch action.'
    end
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
