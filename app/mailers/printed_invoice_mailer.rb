class PrintedInvoiceMailer < ActionMailer::Base
  def notify_sender(share, subject, params, document)
    attachments[params[:file_name]] = File.read(document.file.path)
    mail(
      from: share.sender,
      to: share.receiver,
      subject: subject,
      content_type: 'text/html; charset=UTF-8',
      body: params[:mail_content])
  end
end
