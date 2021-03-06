class AppProxyController < ApplicationController
  include ShopifyApp::AppProxyVerification

  before_action :initialize_klaviyo, only: [:vet_create, :vet_event_create]

  include ApplicationHelper

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

  def vet_create
    shop = Shop.find_by_shopify_domain(params[:shop])
    params[:customer][:accepts_marketing] = (params[:customer][:accepts_marketing] == 'on' ? true : false)
    begin
      shop.with_shopify_session do
        customer_meta = []
        customer_meta.push(
          key: "title",
          value: "#{vet_meta_params[:title]}",
          value_type: "string",
          namespace: "veterinarian"
          )
        customer_meta.push(
          key: "clinic_name",
          value: "#{vet_meta_params[:clinic_name]}",
          value_type: "string",
          namespace: "veterinarian"
          )
        customer_meta.push(
          key: "agree_terms",
          value: "#{vet_meta_params[:agree_terms]}",
          value_type: "string",
          namespace: "veterinarian"
          )


        response = HTTP.headers("X-Shopify-Access-Token" => "#{shop.shopify_token}").get("https://#{shop.shopify_domain}/admin/api/2019-04/customers/search.json?query=email:#{vet_params[:email]}").body.to_s
        customer_id = nil
        if response.presence
          response = JSON.parse(response)
          if response["customers"].presence
            customer_id = response["customers"][0]["id"]
          end
        end

        if vet_params[:accepts_marketing]
          @account.with_klaviyo_session do
            member = KlaviyoAPI::ListMember.first params: { list_id: ENV["KLAVIYO_LIST_ID"], emails: vet_params[:email] }
            if member.present?
              member.destroy
            end
            
            member = KlaviyoAPI::ListMember.create vet_params.slice(:first_name, :last_name, :email, :accepts_marketing, :tags).merge(vet_meta_params).merge(address_params).permit!.merge(list_id: ENV["KLAVIYO_LIST_ID"]).merge(vet_title: vet_meta_params[:title])
          end
        end

        if customer_id.presence
          puts "Customer ID: #{customer_id}"
          response = HTTP.accept("application/json").headers("X-Shopify-Access-Token" => "#{shop.shopify_token}").put("https://#{shop.shopify_domain}/admin/api/2019-04/customers/#{customer_id}.json",
            :json => { :customer => vet_params.merge(metafield: customer_meta).merge(addresses: [address_params.to_h]).merge(password_confirmation: vet_params[:password]).merge(id: customer_id) }
          )
          puts vet_params.merge(metafield: customer_meta).merge(addresses: [address_params.to_h]).merge(password_confirmation: vet_params[:password]).merge(id: customer_id)
          puts response.inspect
        else
          customer = ShopifyAPI::Customer.create vet_params.merge(metafield: customer_meta).merge(addresses: [address_params]).merge(password_confirmation: vet_params[:password])
          response = HTTP.accept("application/json").headers("X-Shopify-Access-Token" => "#{shop.shopify_token}").put("https://#{shop.shopify_domain}/admin/api/2019-04/customers/#{customer.id}.json",
            :json => { :customer => {metafield: customer_meta, id: customer.id} }
          )
        end
      end
    rescue Exception => e
      puts e
    end
    redirect_to "https://us.lintbells.com/account/login/multipass/#{multipass_token(vet_params, ENV["VET_PAGE"])}"
  end

  def vet_join
    render layout: false, content_type: 'application/liquid'
  end

  def vet_event_create
    shop = Shop.find_by_shopify_domain(params[:shop])
    params[:customer][:accepts_marketing] = (params[:customer][:accepts_marketing] == 'on' ? true : false)
    begin
      shop.with_shopify_session do
        customer_meta = []
        customer_meta.push(
          key: "title",
          value: "#{vet_meta_params[:title]}",
          value_type: "string",
          namespace: "veterinarian"
          )
        customer_meta.push(
          key: "clinic_name",
          value: "#{vet_meta_params[:clinic_name]}",
          value_type: "string",
          namespace: "veterinarian"
          )
        customer_meta.push(
          key: "agree_terms",
          value: "#{vet_meta_params[:agree_terms]}",
          value_type: "string",
          namespace: "veterinarian"
          )

        customer_meta.push(
          key: "dog_name",
          value: "#{vet_meta_params[:dog_name]}",
          value_type: "string",
          namespace: "veterinarian"
          )

        customer_meta.push(
          key: "dog_age",
          value: "#{vet_meta_params[:dog_age]}",
          value_type: "string",
          namespace: "veterinarian"
          )
        customer_meta.push(
          key: "dog_weight",
          value: "#{vet_meta_params[:dog_weight]}",
          value_type: "string",
          namespace: "veterinarian"
          )
        customer_meta.push(
          key: "dog_breed",
          value: "#{vet_meta_params[:dog_breed]}",
          value_type: "string",
          namespace: "veterinarian"
          )

        response = HTTP.headers("X-Shopify-Access-Token" => "#{shop.shopify_token}").get("https://#{shop.shopify_domain}/admin/api/2019-04/customers/search.json?query=email:#{vet_params[:email]}").body.to_s
        customer_id = nil
        if response.presence
          response = JSON.parse(response)
          if response["customers"].presence
            customer_id = response["customers"][0]["id"]
          end
        end

        if vet_params[:accepts_marketing]
          @account.with_klaviyo_session do
            member = KlaviyoAPI::ListMember.first params: { list_id: ENV["KLAVIYO_EVENT_LIST_ID"], emails: vet_params[:email] }
            if member.present?
              member.destroy
            end
            
            member = KlaviyoAPI::ListMember.create vet_params.slice(:first_name, :last_name, :email, :accepts_marketing, :tags).merge(vet_meta_params).merge(address_params).permit!.merge(list_id: ENV["KLAVIYO_EVENT_LIST_ID"]).merge(vet_title: vet_meta_params[:title])
          end
        end

        if customer_id.presence
          puts "Customer ID: #{customer_id}"
          response = HTTP.accept("application/json").headers("X-Shopify-Access-Token" => "#{shop.shopify_token}").put("https://#{shop.shopify_domain}/admin/api/2019-04/customers/#{customer_id}.json",
            :json => { :customer => vet_params.merge(metafield: customer_meta).merge(addresses: [address_params.to_h]).merge(password_confirmation: vet_params[:password]).merge(id: customer_id) }
          )
          puts vet_params.merge(metafield: customer_meta).merge(addresses: [address_params.to_h]).merge(password_confirmation: vet_params[:password]).merge(id: customer_id)
          puts response.inspect
        else
          customer = ShopifyAPI::Customer.create vet_params.merge(metafield: customer_meta).merge(addresses: [address_params]).merge(password_confirmation: vet_params[:password])
          response = HTTP.accept("application/json").headers("X-Shopify-Access-Token" => "#{shop.shopify_token}").put("https://#{shop.shopify_domain}/admin/api/2019-04/customers/#{customer.id}.json",
            :json => { :customer => {metafield: customer_meta, id: customer.id} }
          )
        end
      end
    rescue Exception => e
      puts e
    end
    redirect_to "https://us.lintbells.com/account/login/multipass/#{multipass_token(vet_params, ENV["VET_REDIRECT_FOR_EVENT"])}"
  end

  def vet_event_join
    render layout: false, content_type: 'application/liquid'
  end
  
  private
  def customer_params
    params.require(:customer).permit(:first_name, :last_name, :email, :password, :accepts_marketing, :title, :agree_terms, :address1, :address2, :city, :province, :country, :zip, :tags, :clinic_name, :dog_name, :dog_age, :dog_weight, :dog_breed)
  end
  def vet_params
    customer_params.slice(:first_name, :last_name, :email, :password, :accepts_marketing, :tags)
  end

  def vet_meta_params
    customer_params.slice(:title, :agree_terms, :clinic_name, :dog_name, :dog_age, :dog_weight, :dog_breed)
  end

  def address_params
    customer_params.slice(:address1, :address2, :city, :province, :country, :zip, :first_name, :last_name)
  end

  def initialize_klaviyo
    @account = Account.new ENV['KLAVIYO_API_KEY']
  end

  def permit!
    each_pair do |key, value|
      convert_hashes_to_parameters(key, value)
      self[key].permit! if self[key].respond_to? :permit!
    end

    @permitted = true
    self
  end

  def multipass_token(data, redirect_to)
    customer_data = {
      email: data[:email],
      first_name: data[:first_name],
      last_name: data[:last_name],
      return_to: redirect_to
    }

    ShopifyMultipass.new(ENV['SHOPIFY_MULTIPASS_SECRET']).generate_token(customer_data)
  end
end
