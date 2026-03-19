# frozen_string_literal: true

require "test_helper"

class TestSubscriptionPhase < Minitest::Test
  include FrameTest::Fixtures
  include FrameTest::APIOperations

  def test_retrieve_subscription_phase
    subscription_id = "sub_1234567890abcdef"
    phase_id = "sph_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/subscriptions/#{subscription_id}/phases/#{phase_id}",
      "subscription_phase.json"
    )

    phase = Frame::SubscriptionPhase.retrieve(subscription_id, phase_id)
    assert_equal phase_id, phase.id
    assert_equal "subscription_phase", phase.object
  end

  def test_create_subscription_phase
    subscription_id = "sub_1234567890abcdef"
    stub_api_request(
      :post,
      "/v1/subscriptions/#{subscription_id}/phases",
      "subscription_phase.json"
    )

    phase = Frame::SubscriptionPhase.create(
      subscription_id,
      start_date: 1736995552,
      end_date: 1739677552
    )

    assert_equal "sph_1234567890abcdef", phase.id
    assert_equal "subscription_phase", phase.object
  end

  def test_update_subscription_phase
    subscription_id = "sub_1234567890abcdef"
    phase_id = "sph_1234567890abcdef"

    stub_api_request(
      :get,
      "/v1/subscriptions/#{subscription_id}/phases/#{phase_id}",
      "subscription_phase.json"
    )

    stub_api_request(
      :patch,
      "/v1/subscriptions/#{subscription_id}/phases/#{phase_id}",
      "subscription_phase.json"
    )

    phase = Frame::SubscriptionPhase.retrieve(subscription_id, phase_id)
    phase.save(metadata: {key: "value"})

    assert_requested :patch, "#{Frame.api_base}/v1/subscriptions/#{subscription_id}/phases/#{phase_id}", times: 1
  end

  def test_list_subscription_phases
    subscription_id = "sub_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/subscriptions/#{subscription_id}/phases",
      "subscription_phases_list.json"
    )

    phases = Frame::SubscriptionPhase.list(subscription_id)
    assert_equal 2, phases.data.size
    assert_equal "sph_1234567890abcdef", phases.data.first.id
    assert_equal "sph_abcdef1234567890", phases.data.last.id

    assert_equal false, phases.has_more?
    assert_equal 1, phases.instance_variable_get(:@page)
  end

  def test_list_subscription_phases_with_params
    subscription_id = "sub_1234567890abcdef"
    stub_api_request(
      :get,
      "/v1/subscriptions/#{subscription_id}/phases",
      "subscription_phases_list.json",
      request_params: {page: 1, per_page: 20}
    )

    phases = Frame::SubscriptionPhase.list(subscription_id, page: 1, per_page: 20)

    assert_equal 2, phases.data.size
    assert_requested :get, "#{Frame.api_base}/v1/subscriptions/#{subscription_id}/phases",
      query: {page: 1, per_page: 20},
      times: 1
  end

  def test_delete_subscription_phase
    subscription_id = "sub_1234567890abcdef"
    phase_id = "sph_1234567890abcdef"

    stub_api_request(
      :delete,
      "/v1/subscriptions/#{subscription_id}/phases/#{phase_id}",
      "deleted_subscription_phase.json"
    )

    deleted_phase = Frame::SubscriptionPhase.delete(subscription_id, phase_id)

    assert_equal phase_id, deleted_phase.id
    assert_equal true, deleted_phase.deleted
    assert_equal "subscription_phase", deleted_phase.object

    assert_requested :delete, "#{Frame.api_base}/v1/subscriptions/#{subscription_id}/phases/#{phase_id}", times: 1
  end
end
