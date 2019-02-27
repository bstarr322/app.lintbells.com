class CustomerMailer < ApplicationMailer
  default from: ENV["GMAIL_ADDRESS"]

  def activate_email
    @customer = params[:customer]
    @url = params[:url]
    mail(to: @customer.email, subject: 'Activate your Lintbells account')
  end
end