require "letter_opener"
class OrderMailer < ApplicationMailer

  default from: 'sangeetadhiman2003@gmail.com'

  def send_email(user)
   @user = user
   @subject = "Greeting"
   @message = "How are you?"
   attachments['/home/developer/Downloads/Invoice@1-1.pdf']=File.read('//home/developer/Downloads/Invoice@1-1.pdf')
   mail(to:@user.email, subject: @subject)
  end
end
