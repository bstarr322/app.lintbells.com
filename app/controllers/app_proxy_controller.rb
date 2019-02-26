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
        customer.first_name = params[:customer][:first_name]
        customer.last_name = params[:customer][:last_name]
        customer.password = params[:customer][:password]
        customer.password_confirmation = params[:customer][:password_confirmation]
        customer.accepts_marketing = params[:customer][:accepts_marketing]
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
        for i in 0..(params[:customer][:num_of_doggies] - 1)
          dogs_meta.push(
            key: "dog_name_#{i}",
            value: "#{params[:dog_names][i]}",
            value_type: "string",
            namespace: "dog"
            )
          dogs_meta.push(
            key: "sex_#{i}",
            value: "#{params[:sex][i]}",
            value_type: "string",
            namespace: "dog"
            )
          dogs_meta.push(
            key: "dog_year_#{i}",
            value: "#{params[:dog_year][i]}",
            value_type: "string",
            namespace: "dog"
            )
          dogs_meta.push(
            key: "dog_breed_#{i}",
            value: "#{params[:dog_breed][i]}",
            value_type: "string",
            namespace: "dog"
            )
        end
        # ShopifyAPI::Customer.create(
        #   first_name: params[:customer][:first_name],
        #   last_name: params[:customer][:last_name],
        #   password: params[:customer][:password],
        #   password_confirmation: params[:customer][:password],
        #   accepts_marketing: params[:customer][:accepts_marketing],
        #   metafields: dogs_meta
        # )
        a = {
          first_name: params[:customer][:first_name],
          last_name: params[:customer][:last_name],
          password: params[:customer][:password],
          password_confirmation: params[:customer][:password],
          accepts_marketing: params[:customer][:accepts_marketing],
          metafields: dogs_meta
        }
        puts a 
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
