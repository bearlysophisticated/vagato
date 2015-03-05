require 'test_helper'

class FilterControllerTest < ActionController::TestCase
  test "should get search" do
    get :filter
    assert_response :success
  end

end
