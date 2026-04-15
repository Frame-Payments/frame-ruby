# frozen_string_literal: true

require "test_helper"

class TestCapability < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_list_capabilities
    account_id = "acct_123"
    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}/capabilities",
      "capabilities_list.json"
    )

    result = Frame::FrameClient.active_client.request(:get, "/v1/accounts/#{account_id}/capabilities")
    response = Frame::Util.convert_to_frame_object(result)
    assert_equal 1, response.data.size
    assert_equal "payments", response.data.first.name
    assert_equal "active", response.data.first.status
    assert_equal "capability", response.data.first.object

    assert_requested :get, "#{Frame.api_base}/v1/accounts/#{account_id}/capabilities", times: 1
  end

  def test_request_capabilities
    account_id = "acct_123"
    stub_api_request(
      :post,
      "/v1/accounts/#{account_id}/capabilities",
      "capability.json"
    )

    result = Frame::FrameClient.active_client.request(:post, "/v1/accounts/#{account_id}/capabilities", {capabilities: ["payments"]})
    response = Frame::Util.convert_to_frame_object(result)
    assert_equal "payments", response.name
    assert_equal "active", response.status
    assert_equal "capability", response.object

    assert_requested :post, "#{Frame.api_base}/v1/accounts/#{account_id}/capabilities", times: 1
  end

  def test_retrieve_capability
    account_id = "acct_123"
    capability_name = "payments"
    stub_api_request(
      :get,
      "/v1/accounts/#{account_id}/capabilities/#{capability_name}",
      "capability.json"
    )

    result = Frame::FrameClient.active_client.request(:get, "/v1/accounts/#{account_id}/capabilities/#{capability_name}")
    response = Frame::Util.convert_to_frame_object(result)
    assert_equal "payments", response.name
    assert_equal "active", response.status
    assert_equal "capability", response.object

    assert_requested :get, "#{Frame.api_base}/v1/accounts/#{account_id}/capabilities/#{capability_name}", times: 1
  end

  def test_disable_capability
    account_id = "acct_123"
    capability_name = "payments"
    stub_api_request(
      :delete,
      "/v1/accounts/#{account_id}/capabilities/#{capability_name}",
      "capability.json"
    )

    result = Frame::FrameClient.active_client.request(:delete, "/v1/accounts/#{account_id}/capabilities/#{capability_name}")
    response = Frame::Util.convert_to_frame_object(result)
    assert_equal "payments", response.name
    assert_equal "capability", response.object

    assert_requested :delete, "#{Frame.api_base}/v1/accounts/#{account_id}/capabilities/#{capability_name}", times: 1
  end
end
