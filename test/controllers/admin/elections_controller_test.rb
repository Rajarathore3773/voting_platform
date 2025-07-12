require "test_helper"

class Admin::ElectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get admin_elections_index_url
    assert_response :success
  end

  test "should get new" do
    get admin_elections_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_elections_create_url
    assert_response :success
  end
end
