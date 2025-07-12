require "test_helper"

class ElectionsControllerTest < ActionDispatch::IntegrationTest
  test "should get show" do
    get elections_show_url
    assert_response :success
  end

  test "should get ballot" do
    get elections_ballot_url
    assert_response :success
  end

  test "should get submit_ballot" do
    get elections_submit_ballot_url
    assert_response :success
  end

  test "should get results" do
    get elections_results_url
    assert_response :success
  end
end
