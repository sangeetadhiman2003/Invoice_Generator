require "letter_opener"
class OrderMailer < ApplicationMailer
  default from: 'sangeetadhiman2003@gmail.com'
  def send_email(user, subject, message)
   @user = user
   @subject = subject
   @message = message
   attachments['/home/developer/Downloads/nisha kumari.pdf']=File.read('/home/developer/Downloads/nisha kumari.pdf')
   mail(to:@user.email, subject: @subject)
  end
end
