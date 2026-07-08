# frozen_string_literal: true

# This file loads all Frame Payments API resources.
# Resources are organized alphabetically for maintainability.

# Accounts
require "frame/resources/account"
require "frame/resources/capability"
require "frame/resources/phone_verification"

# Customer management
require "frame/resources/customer"
require "frame/resources/customer_identity_verification"

# Payment processing
require "frame/resources/bank_account"
require "frame/resources/charge"
require "frame/resources/charge_intent"
require "frame/resources/charge_session"
require "frame/resources/payment_method"
require "frame/resources/refund"
require "frame/resources/sonar_session"
require "frame/resources/three_ds_intent"

# Disputes
require "frame/resources/dispute"

# Invoicing
require "frame/resources/invoice"
require "frame/resources/invoice_line_item"

# Onboarding
require "frame/resources/geofence"
require "frame/resources/onboarding"
require "frame/resources/onboarding_session"

# Billing
require "frame/resources/billing"
require "frame/resources/coupon"
require "frame/resources/discount"
require "frame/resources/promotion_code"

# Subscriptions
require "frame/resources/product"
require "frame/resources/product_phase"
require "frame/resources/subscription"
require "frame/resources/subscription_change_log"
require "frame/resources/subscription_phase"

# Payouts & Transfers
require "frame/resources/payment_link_session"
require "frame/resources/payout"
require "frame/resources/transfer"
require "frame/resources/transfer_billing_agreement"
require "frame/resources/transfer_fee_plan"

# Terms of Service
require "frame/resources/terms_of_service"

# Merchant
require "frame/resources/merchant_balance"

# Webhooks
require "frame/resources/webhook_endpoint"
