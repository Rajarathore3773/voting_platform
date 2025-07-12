require "test_helper"

class Admin::CandidatesControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get admin_candidates_new_url
    assert_response :success
  end

  test "should get create" do
    get admin_candidates_create_url
    assert_response :success
  end
end
