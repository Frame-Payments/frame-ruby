# frozen_string_literal: true

module Frame
  class Billing < APIResource
    OBJECT_NAME = "billing"

    def self.object_name; OBJECT_NAME; end

    def self.create_metering(params = {}, opts = {})
      request_object(:post, "/v1/billing/metering", params, opts)
    end

    def self.get_metering(id, opts = {})
      request_object(:get, "/v1/billing/metering/#{CGI.escape(id)}", {}, opts)
    end

    def self.update_metering(id, params = {}, opts = {})
      request_object(:patch, "/v1/billing/metering/#{CGI.escape(id)}", params, opts)
    end

    def self.create_metering_event(params = {}, opts = {})
      request_object(:post, "/v1/billing/metering_events", params, opts)
    end

    def self.get_metering_event(id, opts = {})
      request_object(:get, "/v1/billing/metering_events/#{CGI.escape(id)}", {}, opts)
    end

    def self.update_metering_event(id, params = {}, opts = {})
      request_object(:patch, "/v1/billing/metering_events/#{CGI.escape(id)}", params, opts)
    end

    def self.create_billing_invoice(params = {}, opts = {})
      request_object(:post, "/v1/billing/billing_invoice", params, opts)
    end

    def self.create_billing_credit(params = {}, opts = {})
      request_object(:post, "/v1/billing/billing_credit", params, opts)
    end

    def self.get_billing_credit(id, opts = {})
      request_object(:get, "/v1/billing/billing_credit/#{CGI.escape(id)}", {}, opts)
    end

    def self.customer_report(params = {}, opts = {})
      request_object(:get, "/v1/billing/report/customer", params, opts)
    end

    def self.event_report(event_name, params = {}, opts = {})
      request_object(:get, "/v1/billing/report/event/#{CGI.escape(event_name)}", params, opts)
    end

    def self.events_report(params = {}, opts = {})
      request_object(:get, "/v1/billing/report/events", params, opts)
    end

    def self.subscription_report(params = {}, opts = {})
      request_object(:get, "/v1/billing/report/subscription", params, opts)
    end
  end
end
