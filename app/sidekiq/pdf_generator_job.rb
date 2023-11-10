class PdfGeneratorJob
  include Sidekiq::Job

  def perform(layout, template, locals)
    # invoices = Invoice.where(id: selected_invoice_ids)


    html_content = []

    # invoices.each do |invoice|
    #   @invoice = invoice
    #   @items = @invoice.items
    #   html_content << render_to_string(layout: 'layouts/pdf_layout', template: 'invoices/show.html.erb', locals: { invoice: @invoice })
    # end

    combined_html = html_content.join("\n")

    pdf_data = WickedPdf.new.pdf_from_string(combined_html)

    send_data pdf_data, type: "application/pdf", filename: "combined_invoices.pdf"

  end
end
