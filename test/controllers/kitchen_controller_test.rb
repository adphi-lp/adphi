require 'test_helper'

class KitchenControllerTest < ActionController::TestCase
  test "should get roster" do
    get :roster
    assert_response :success
  end

end
