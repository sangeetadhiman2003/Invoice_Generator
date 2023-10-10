require "letter_opener"
class OrderMailer < ApplicationMailer
  def send_email(user, subject, message)
   @user = user
   @subject = subject
   @message = message

   mail(to:@user.email, subject: @subject)
  end
end
