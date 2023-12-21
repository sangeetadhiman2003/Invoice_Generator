require "letter_opener"
class OrderMailer < ApplicationMailer

  default from: 'sangeetadhiman2003@gmail.com'

  def send_email(user)
    @user = user
    @subject = "Greeting"
    @message = "How are you?"
    # TODO: can it be dynamic
    attachments['/home/developer/Downloads/Invoice@1-1.pdf'] = File.read('//home/developer/Downloads/Invoice@1-1.pdf')
    mail(to: @user.email, subject: @subject)
  end



  def invoices_pdf_email(user, pdf_data, combined_pdf_filename)
    @user = user
    attachments[combined_pdf_filename] = { mime_type: 'application/pdf', content: pdf_data }

    # Provide the email body as a string directly
    mail(to: @user.email, subject: 'Invoices PDFs') do |format|
      format.html { render plain: 'Please find the attached PDFs.' }
    end
  end

end
