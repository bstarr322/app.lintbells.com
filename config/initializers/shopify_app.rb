ShopifyApp.configure do |config|
  config.application_name = "LintBells App"
  config.api_key = ENV["SHOPIFY_CLIENT_API_KEY"]
  config.secret = ENV["SHOPIFY_CLIENT_API_SECRET"]
  config.scope = "read_products,read_themes,read_content,read_product_listings,read_customers,write_customers,read_orders,write_orders,read_locations,read_checkouts,read_price_rules"
  config.embedded_app = false
  config.after_authenticate_job = false
  config.session_repository = Shop
end
