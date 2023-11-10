class EmailSenderJob
  include Sidekiq::Job

  debugger
  def perform(user_id)
    user = User.find(user_id)
    OrderMailer.send_email(user).deliver_now
  end
end
