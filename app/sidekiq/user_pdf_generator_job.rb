class UserPdfGeneratorJob
  include Sidekiq::Job


  def perform(user_id, html_content, template_path, layout)
    user = User.find_by(id: user_id)
    return unless user

    pdf_html = ApplicationController.new.render_to_string(
      inline: html_content,
      template: template_path,
      layout: "pdf/#{layout}.html.erb",
      locals: { user: user }
    )

    pdf = WickedPdf.new.pdf_from_string(pdf_html)

    File.open("user_#{user.id}_details.pdf", 'wb') do |file|
      file << pdf
    end
  end

end
