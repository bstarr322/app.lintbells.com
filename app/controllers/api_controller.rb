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

  def customer_update
    begin
      customer = ShopifyAPI::Customer.find(params[:customer][:id])
      customer.first_name = params[:customer][:first_name]
      customer.last_name = params[:customer][:last_name]
      customer.password = params[:customer][:password]
      customer.password_confirmation = params[:customer][:password_confirmation]
      customer.accepts_marketing = params[:customer][:accepts_marketing]
      customer.save
      render json: {success: true}, status: :ok
    rescue Exception => e
      puts e
      render json: {success: false}, status: :ok
    end
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
end