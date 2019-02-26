class CustomerMailer < ApplicationMailer
  default from: ENV["GMAIL_ADDRESS"]
  def activate_email(customer, url)
    @customer = customer
    @url  = url
    mail(to: @customer.email, subject: 'Activate your Lintbells account')
  end
end