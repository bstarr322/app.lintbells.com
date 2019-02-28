class AppProxyController < ApplicationController
   include ShopifyApp::AppProxyVerification

  def index
    render layout: false, content_type: 'application/liquid'
  end

  def update
    shop = Shop.first
    begin
      shop.with_shopify_session do
        customer = ShopifyAPI::Customer.find(params[:customer][:id])
        # customer.id = params[:customer][:id]
        customer.first_name = params[:customer][:first_name]
        customer.last_name = params[:customer][:last_name]
        # customer.email = params[:customer][:email]
        customer.password = params[:customer][:password]
        customer.password_confirmation = params[:customer][:password_confirmation]
        # customer.accepts_marketing = params[:customer][:accepts_marketing]
        customer.save
      end
    rescue Exception => e
      puts e
    end
    redirect_to "https://us.lintbells.com/account"
  end

  def create
    shop = Shop.first
    begin
      shop.with_shopify_session do
        dogs_meta = []
        dogs_meta.push(
          key: "num_of_doggies",
          value: "#{params[:customer][:num_of_doggies].to_i}",
          value_type: "integer",
          namespace: "dog"
          )
        for i in 0..(params[:customer][:num_of_doggies].to_i - 1)
          dogs_meta.push(
            key: "dog_name_#{i}",
            value: "#{params[:dog_names][i.to_s]}",
            value_type: "string",
            namespace: "dog"
            )
          dogs_meta.push(
            key: "sex_#{i}",
            value: "#{params[:sex][i.to_s]}",
            value_type: "string",
            namespace: "dog"
            )
          dogs_meta.push(
            key: "dog_year_#{i}",
            value: "#{params[:dog_year][i.to_s]}",
            value_type: "string",
            namespace: "dog"
            )
          dogs_meta.push(
            key: "dog_breed_#{i}",
            value: "#{params[:dog_breed][i.to_s]}",
            value_type: "string",
            namespace: "dog"
            )
        end
        customer = ShopifyAPI::Customer.create(
          first_name: params[:customer][:first_name],
          last_name: params[:customer][:last_name],
          email: params[:customer][:email],
          password: params[:customer][:password],
          password_confirmation: params[:customer][:password],
          accepts_marketing: params[:customer][:accepts_marketing] == 'on' ? true : false,
          metafields: dogs_meta
        )
        # url = customer.account_activation_url
        # CustomerMailer.with(customer: customer, url: url).activate_email.deliver_now
        # a = {
        #   first_name: params[:customer][:first_name],
        #   last_name: params[:customer][:last_name],
        #   password: params[:customer][:password],
        #   password_confirmation: params[:customer][:password],
        #   accepts_marketing: params[:customer][:accepts_marketing] == 'on' ? true : false,
        #   metafields: dogs_meta
        # }
        # puts a 
      end
    rescue Exception => e
      puts e
    end
    redirect_to "https://us.lintbells.com/account"
  end

  def join
    render layout: false, content_type: 'application/liquid'
  end
end
