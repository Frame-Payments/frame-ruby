# Frame Payments - Ruby SDK

A Ruby library for the Frame Payments API.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'frame_payments'
```

And then execute:

```bash
bundle install
```

Or install it yourself as:

```bash
gem install frame_payments
```

## Usage

> Note: The gem name is `frame_payments`, but the Ruby namespace is `Frame`.

The library needs to be configured with your Frame API key:

```ruby
require 'frame_payments'
Frame.api_key = 'your_api_key'
```

### Configuration Options

```ruby
# Configure API settings
Frame.api_key = 'your_api_key'
Frame.api_base = 'https://api.framepayments.com'  # Default
Frame.open_timeout = 30  # Connection timeout in seconds
Frame.read_timeout = 80  # Read timeout in seconds
Frame.verify_ssl_certs = true  # SSL verification (default: true)

# Optional: Enable logging (sensitive data is automatically redacted)
require 'logger'
Frame.logger = Logger.new(STDOUT)
Frame.log_level = :info  # :debug, :info, :warn, :error
```

### Customers

**Create a customer:**

```ruby
customer = Frame::Customer.create(
  name: 'John Doe',
  email: 'john@example.com',
  phone: '+12345678900',
  metadata: {
    user_id: '12345'
  }
)
```

**Retrieve a customer:**

```ruby
customer = Frame::Customer.retrieve('cus_123456789')
```

**Update a customer:**

```ruby
customer = Frame::Customer.retrieve('cus_123456789')
customer.name = 'Jane Doe'
customer.save

# Alternative approach
customer = Frame::Customer.retrieve('cus_123456789')
customer.save(name: 'Jane Doe')
```

**List all customers:**

```ruby
customers = Frame::Customer.list
customers.each do |customer|
  puts "Customer: #{customer.name}, Email: #{customer.email}"
end

# With pagination
customers = Frame::Customer.list(page: 1, per_page: 20)
```

**Search customers:**

```ruby
customers = Frame::Customer.search(name: 'John')
```

**Delete a customer:**

```ruby
Frame::Customer.delete('cus_123456789')
# or
customer = Frame::Customer.retrieve('cus_123456789')
customer.delete
```

**Block/unblock a customer:**

```ruby
customer = Frame::Customer.retrieve('cus_123456789')
customer.block

# Unblock
customer.unblock
```

### Charge Intents

**Create a charge intent:**

```ruby
charge_intent = Frame::ChargeIntent.create(
  amount: 10000,
  currency: 'usd',
  customer: 'cus_123456789',
  payment_method: 'pm_123456789',
  description: 'Payment for order #123'
)
```

Optional: include `sonar_session_id` (string) when creating a charge intent to link the transaction to a Frame Sonar session for fraud protection (e.g. the value from `frame_charge_session_id` in client storage). See [Frame Sonar documentation](https://docs.framepayments.com/guides/sonar-fraud-protection).

**Retrieve, list, and update:**

```ruby
# Retrieve
intent = Frame::ChargeIntent.retrieve('ci_123456789')

# List
intents = Frame::ChargeIntent.list(page: 1, per_page: 20)

# Update
intent.description = 'Updated description'
intent.save
```

**Authorize, capture, or cancel:**

```ruby
intent = Frame::ChargeIntent.retrieve('ci_123456789')
intent.authorize  # Authorize the payment
intent.capture    # Capture the authorized amount
intent.cancel     # Cancel the intent
```

### Payment Methods

**Create a payment method:**

```ruby
payment_method = Frame::PaymentMethod.create(
  type: 'card',
  card: {
    number: '4242424242424242',
    exp_month: 12,
    exp_year: 2025,
    cvc: '123'
  }
)
```

**Attach to a customer:**

```ruby
payment_method.attach('cus_123456789')
# or
Frame::PaymentMethod.attach('pm_123456789', 'cus_123456789')
```

**List and manage:**

```ruby
# List all payment methods
methods = Frame::PaymentMethod.list(customer: 'cus_123456789')

# Detach from customer
payment_method.detach

# Delete
payment_method.delete
```

### Refunds

**Create a refund:**

```ruby
refund = Frame::Refund.create(
  charge: 'ch_123456789',
  amount: 5000,  # Amount in cents, or omit for full refund
  reason: 'requested_by_customer'
)
```

**Retrieve and list:**

```ruby
refund = Frame::Refund.retrieve('rf_123456789')
refunds = Frame::Refund.list(charge: 'ch_123456789')
```

**Cancel a refund:**

```ruby
refund.cancel
```

### Invoices

**Create an invoice:**

```ruby
invoice = Frame::Invoice.create(
  customer: 'cus_123456789',
  total: 10000,
  currency: 'usd',
  due_date: Time.now.to_i + 86400  # 24 hours from now
)
```

**Manage invoice lifecycle:**

```ruby
invoice = Frame::Invoice.retrieve('inv_123456789')

# Finalize (make it payable)
invoice.finalize

# Mark as paid
invoice.pay(payment_method: 'pm_123456789')

# Void
invoice.void
```

**List invoices:**

```ruby
invoices = Frame::Invoice.list(customer: 'cus_123456789', status: 'paid')
```

### Invoice Line Items

**Create a line item:**

```ruby
line_item = Frame::InvoiceLineItem.create(
  invoice: 'inv_123456789',
  description: 'Product or service',
  quantity: 2,
  unit_amount: 5000
)
```

**Update and delete:**

```ruby
line_item.quantity = 3
line_item.save
line_item.delete
```

### Subscriptions

**Create a subscription:**

```ruby
subscription = Frame::Subscription.create(
  customer: 'cus_123456789',
  product_phase: 'pph_123456789',
  payment_method: 'pm_123456789'
)
```

**Manage subscription:**

```ruby
subscription = Frame::Subscription.retrieve('sub_123456789')

# Pause
subscription.pause

# Resume
subscription.resume

# Cancel
subscription.cancel
```

**List subscriptions:**

```ruby
subscriptions = Frame::Subscription.list(customer: 'cus_123456789', status: 'active')
```

### Products

**Create a product:**

```ruby
product = Frame::Product.create(
  name: 'Premium Plan',
  description: 'A premium subscription plan',
  active: true
)
```

**List products:**

```ruby
products = Frame::Product.list(active: true)
```

### Product Phases

**Create a product phase:**

```ruby
phase = Frame::ProductPhase.create(
  product: 'prod_123456789',
  price: 10000,
  currency: 'usd',
  interval: 'month',
  interval_count: 1
)
```

### Webhook Endpoints

**Create a webhook endpoint:**

```ruby
webhook = Frame::WebhookEndpoint.create(
  url: 'https://example.com/webhook',
  events: ['charge.succeeded', 'charge.failed', 'subscription.created']
)
```

**Enable/disable:**

```ruby
webhook.enable
webhook.disable
```

**List webhooks:**

```ruby
webhooks = Frame::WebhookEndpoint.list
```

### Customer Identity Verifications

**Create a verification:**

```ruby
verification = Frame::CustomerIdentityVerification.create(
  customer: 'cus_123456789',
  type: 'identity_document'
)
```

**Verify:**

```ruby
verification.verify
```

**List verifications:**

```ruby
verifications = Frame::CustomerIdentityVerification.list(customer: 'cus_123456789')
```

### Error Handling

```ruby
begin
  customer = Frame::Customer.retrieve('invalid_id')
rescue Frame::InvalidRequestError => e
  puts "Request failed: #{e.message}"
  puts "HTTP Status: #{e.http_status}"
rescue Frame::AuthenticationError => e
  puts "Authentication failed: #{e.message}"
rescue Frame::RateLimitError => e
  puts "Rate limit exceeded: #{e.message}"
rescue Frame::APIError => e
  puts "API error: #{e.message}"
end
```

### Security Best Practices

#### API Key Management

**Never commit API keys to version control:**

```ruby
# ❌ BAD - Never do this
Frame.api_key = 'sk_live_1234567890abcdef'

# ✅ GOOD - Use environment variables
Frame.api_key = ENV['FRAME_API_KEY']

# ✅ GOOD - Use Rails credentials (Rails apps)
Frame.api_key = Rails.application.credentials.frame_payments[:api_key]

# ✅ GOOD - Use a secrets management service
Frame.api_key = SecretsManager.get('frame_api_key')
```

**Use different keys for different environments:**

```ruby
# Development
Frame.api_key = ENV['FRAME_API_KEY_DEV']

# Production
Frame.api_key = ENV['FRAME_API_KEY_PROD']
```

#### SSL Verification

**Always keep SSL verification enabled in production:**

```ruby
# ✅ GOOD - Default (secure)
Frame.verify_ssl_certs = true

# ⚠️ Only disable for testing/development if absolutely necessary
Frame.verify_ssl_certs = false  # NOT recommended for production
```

#### Logging

**The SDK automatically redacts sensitive data in logs**, but be cautious:

```ruby
# Logging is optional and off by default
# When enabled, sensitive data (API keys, card numbers, etc.) is automatically redacted
Frame.logger = Logger.new(STDOUT)
Frame.log_level = :info

# Never log raw API responses that might contain sensitive data
# The SDK handles this automatically, but be careful with custom logging
```

#### Secure Data Handling

- **Never log or print API keys** - The SDK redacts them automatically, but avoid custom logging of authentication headers
- **Use HTTPS only** - The SDK uses HTTPS by default (`https://api.framepayments.com`)
- **Validate input** - Always validate user input before sending to the API
- **Handle errors securely** - Don't expose sensitive error details to end users
- **Keep dependencies updated** - Regularly update the SDK and its dependencies

#### Environment Variables

**Recommended setup using environment variables:**

```bash
# .env file (add to .gitignore)
export FRAME_API_KEY='sk_live_your_key_here'
export FRAME_API_BASE='https://api.framepayments.com'
```

```ruby
# In your application
require 'dotenv/load'  # If using dotenv gem
Frame.api_key = ENV['FRAME_API_KEY']
Frame.api_base = ENV.fetch('FRAME_API_BASE', 'https://api.framepayments.com')
```

#### Thread Safety

The SDK is designed to be thread-safe. The default client uses thread-safe initialization, and each thread can have its own client instance if needed.

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake test` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/[USERNAME]/frame. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/frame/blob/main/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Frame project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/frame/blob/main/CODE_OF_CONDUCT.md).
