class PdfGeneratorJob
  include Sidekiq::Job

  def perform(invoice_id, html_content, template_path, layout)
  invoice = Invoice.find_by(id: invoice_id)
    return unless invoice

    pdf_html = ApplicationController.new.render_to_string(
      inline: html_content,
      template: template_path,
      layout: "pdf/#{layout}.html.erb",
      locals: { invoice: invoice }
    )

    pdf = WickedPdf.new.pdf_from_string(pdf_html)

    File.open("user_#{invoice.id}_details.pdf", 'wb') do |file|
      file << pdf
    end
  end

end
