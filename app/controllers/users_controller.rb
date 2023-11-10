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
    selected_layout = params[:layout]

    respond_to do |format|
      format.html
      format.pdf do
        pdf = render_to_string pdf: "#{@user.id}", template: 'users/show.html.erb', layout: 'pdf.html.erb'
        send_data pdf, filename: "#{@user.name}.pdf",type: 'application/pdf' , disposition: 'attachment'
      end
    end
  end



  # def download_pdf
  #   @user = User.find(params[:id])
  #   selected_layout = params[:layout] || 'default_layout'
  #   # UserPdfGeneratorJob.perform_async(@user.id)

  #   respond_to do |format|
  #     format.html { render 'show' }
  #     format.pdf do
  #       render pdf: 'user_details',
  #              template: 'users/show.html.erb',
  #              layout: "pdf/#{selected_layout}.html.erb",
  #              xhr: false
  #     end
  #   end
  # end

  def download_pdf
    @user = User.find(params[:id])
    selected_layout = params[:layout] || 'default_layout'

    respond_to do |format|
      format.html { render 'show' }
      format.pdf do
        html_content = render_to_string(template: 'users/show.html.erb')
        template_path = 'users/show.html.erb' # Adjust the path as needed

        # Pass HTML content and template information to the job
        UserPdfGeneratorJob.perform_async(@user.id, html_content, template_path, selected_layout)

        render pdf: 'user_details',
               template: 'users/show.html.erb',
               layout: "pdf/#{selected_layout}.html.erb",
               xhr: false
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

      selected_users.each do |user|
        EmailSenderJob.perform_async(user.id)
        #OrderMailer.send_email(user).deliver_now
      end

      flash[:notice] = "Emails are being sent in the background."

      redirect_to users_path, notice: 'Email shared with selected users.'
    else

      redirect_to users_path, alert: 'Invalid batch action.'
    end
  end



  def select_all
    selected_user_ids = params[:selected_user_ids]
  end

  private

  def user_params
    params.require(:user).permit(:name, :email, :address, :state, :city, :gstin, :pan, :phone, :signature_image)
  end

end
