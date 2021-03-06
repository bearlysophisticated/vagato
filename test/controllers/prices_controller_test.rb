require 'test_helper'

class PricesControllerTest < ActionController::TestCase
  setup do
    @price = prices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:prices)
  end

  test "should get new_owner" do
    get :new_owner
    assert_response :success
  end

  test "should create price" do
    assert_difference('Price.count') do
      post :create, price: { currency: @price.currency, ifa: @price.ifa, room_id: @price.room_id, value: @price.value, vat: @price.vat }
    end

    assert_redirected_to price_path(assigns(:price))
  end

  test "should show price" do
    get :show, id: @price
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @price
    assert_response :success
  end

  test "should update price" do
    patch :update, id: @price, price: { currency: @price.currency, ifa: @price.ifa, room_id: @price.room_id, value: @price.value, vat: @price.vat }
    assert_redirected_to price_path(assigns(:price))
  end

  test "should destroy price" do
    assert_difference('Price.count', -1) do
      delete :destroy, id: @price
    end

    assert_redirected_to prices_path
  end
end
