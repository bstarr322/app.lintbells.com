# require "net/https"
# require "uri"
# require "open-uri"

class ApiController < ActionController::Base
  protect_from_forgery with: :null_session
  layout false

  include ApplicationHelper
  def get_price_rule
    @shop = Shop.first
    response = HTTP.headers("X-Shopify-Access-Token" => "#{@shop.shopify_token}").get("https://#{@shop.shopify_domain}/admin/discount_codes/lookup.json?code=#{URI.escape(params['code'])}").body.to_s
    price_rule = get_rule_data(response)
    render json: price_rule
  end

  def multipass
    invalid = params[:email].blank? || params[:username].blank?
    return render json: {}, status: :not_found if invalid
    customer_data = {
      email: params[:email],
      first_name: params[:username].split(' ').first,
      last_name: params[:username].split(' ').last,
      return_to: "https://us.lintbells.com/checkout"
    }

    token = ShopifyMultipass.new(ENV['SHOPIFY_MULTIPASS_SECRET']).generate_token(customer_data)
    render json: { token: token }, status: :ok
  end


  # @Description: Update Modulus Customer & Pets details
  # @Params:
  #   customer: Modulus Customer ID, leave it blank for new customer.
  #   external_unique_id: Shopify Customer ID,
  #   email: should be unique email for new customer.
  def modulus_update
    # Begin not working in POST why ?
    data = JSON.parse request.raw_post
    shop = Shop.first

    customer_id = data['customer_id']

    if data['signup']
      # If customer already exist in Modulus, just update the details.
      # Check if already exists;
      uri = URI('https://api-lintbells.moduluserp.com/Api/customerandpets/getdetails')

      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true
      http.verify_mode = OpenSSL::SSL::VERIFY_NONE

      req = Net::HTTP::Post.new(uri.path, {
        'Content-Type' =>'application/json',  
        'Authorization' => 'Basic ' + Base64::encode64('apiuser:tef$3KaM2PruY4B')
      })

      req.body = {
        "email" => data['customer']['email'], 
        "customer_id" => "",
        "external_unique_id" => ""
      }.to_json
      res = http.request(req)
      customer = JSON.parse(res.body)

      if customer['customer_id']
        customer_id = customer['customer_id']

        # Remove old pet details
        customer['pet_details'].each do |pet_detail|
          pet_detail['delete_pet'] = true
        end
        data['pet_details'].unshift(*customer['pet_details'])
      else
        create_customer(data)
      end
    end

    uri = URI('https://api-lintbells.moduluserp.com/Api/customerandpets')
    
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path, {
      'Content-Type' =>'application/json',  
      'Authorization' => 'Basic ' + Base64::encode64('apiuser:tef$3KaM2PruY4B')
    })
    req.body = {
      "email" => data['customer']['email'],
      "customer_id" => customer_id,
      "external_unique_id" => "",
      "first_name" => data['customer']['first_name'],
      "last_name" => data['customer']['last_name'],
      "pet_details" => data['pet_details']
    }.to_json

    puts "Modulus -- Post Customer & Pet Details of #{data['customer']['email']}"

    res = http.request(req)

    render json: { data: JSON.parse(res.body) }, status: :ok
  end


  # @Description: Update Modulus Customer & Pets details
  # @Params:
  #   email: Customer email
  #   customer_id: ""
  #   external_unique_id: ""
  def modulus_getdetails
    uri = URI('https://api-lintbells.moduluserp.com/Api/customerandpets/getdetails')

    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE

    req = Net::HTTP::Post.new(uri.path, {
      'Content-Type' =>'application/json',  
      'Authorization' => 'Basic ' + Base64::encode64('apiuser:tef$3KaM2PruY4B')
    })
    req.body = {
      "email" => params[:email], 
      "customer_id" => "",
      "external_unique_id" => ""
    }.to_json
    puts "Modulus -- Get Customer Details of #{params[:email]}"
    res = http.request(req)
    render json: { data: JSON.parse(res.body) }, status: :ok
  end

  def customer_update
    begin
      customer = ShopifyAPI::Customer.find(params[:customer][:id])
      customer.first_name = params[:customer][:first_name]
      customer.last_name = params[:customer][:last_name]
      customer.password = params[:customer][:password]
      customer.password_confirmation = params[:customer][:password_confirmation]
      customer.accepts_marketing = params[:customer][:accepts_marketing]
      customer.save
    rescue Exception => e
      puts e
      # render json: {success: false}, status: :ok
    end
    redirect_to "https://us.lintbells.com/account"
  end

  private
  def get_rule_data(response)
    get_rule /admin\/price_rules[\w\d\/]+/.match(response).to_s
  end
  def get_rule(pattern)
    pattern == "" ? { status: 'error' } : { status: 'ok', rule: request_rule_by_id(pattern.split("/")[2]) }  
  end
  def request_rule_by_id(id)
    @shop.with_shopify_session do
      ShopifyAPI::PriceRule.find(id)
    end
  end


  def create_customer(data)
    shop = Shop.first
    begin
      shop.with_shopify_session do
        customer = ShopifyAPI::Customer.create(
          first_name: data['customer']['first_name'],
          last_name: data['customer']['last_name'],
          email: data['customer']['email'],
          password: data['customer']['password'],
          password_confirmation: data['customer']['password'],
          accepts_marketing: data['customer']['accepts_marketing'] == 'on' ? true : false
        )
      end
    rescue Exception => e
      puts e
    end
  end
end