class EmailSenderJob
  include Sidekiq::Job

  def perform(user_id)
    user = User.find(user_id)
    OrderMailer.send_email(user).deliver_now
  end

  def share_mail_user(user_id, pdf_data, combined_pdf_filename)
    OrderMailer.invoices_pdf_email(user_id, pdf_data, combined_pdf_filename).deliver_now
  end
end
