class OrdersController < ApplicationController
  def create
    @user = User.new(user_params)

    if @user.save
      OrderMailer.with(user: @user).new_user_email.deliver_later

      flash[:success] = "Thank you for your order! We'll get contact you soon!"
      redirect_to root_path
    else
      flash.now[:error] = "Your order form had some errors. Please check the form and resubmit."
      render :new
    end
  end
end
