require "test_helper"

class DelegationsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get delegations_new_url
    assert_response :success
  end

  test "should get create" do
    get delegations_create_url
    assert_response :success
  end

  test "should get index" do
    get delegations_index_url
    assert_response :success
  end
end
