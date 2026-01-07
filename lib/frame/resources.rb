# frozen_string_literal: true

# This file loads all Frame Payments API resources.
# Resources are organized alphabetically for maintainability.

# Customer management
require "frame/resources/customer"
require "frame/resources/customer_identity_verification"

# Payment processing
require "frame/resources/charge_intent"
require "frame/resources/payment_method"
require "frame/resources/refund"

# Invoicing
require "frame/resources/invoice"
require "frame/resources/invoice_line_item"

# Subscriptions
require "frame/resources/product"
require "frame/resources/product_phase"
require "frame/resources/subscription"
require "frame/resources/subscription_phase"

# Webhooks
require "frame/resources/webhook_endpoint"
