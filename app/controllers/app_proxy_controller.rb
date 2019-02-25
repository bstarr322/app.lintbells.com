class AppProxyController < ApplicationController
   include ShopifyApp::AppProxyVerification

  def index
    render layout: false, content_type: 'application/liquid'
  end

  def update
    shop = Shop.first
    begin
      puts 'OK'
      shop.with_shopify_session do
        puts 'OK1'
        puts params[:customer][:id]
        customer = ShopifyAPI::Customer.find(params[:customer][:id])
        customer.first_name = params[:customer][:first_name]
        customer.last_name = params[:customer][:last_name]
        customer.password = params[:customer][:password]
        customer.password_confirmation = params[:customer][:password_confirmation]
        customer.accepts_marketing = params[:customer][:accepts_marketing]
        customer.save
        puts 'OK2'
      end
    rescue Exception => e
      puts e
      puts 'OK3'
      # render json: {success: false}, status: :ok
    end
    redirect_to "https://us.lintbells.com/account"
  end
end
