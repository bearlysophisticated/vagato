require 'test_helper'

class ServiicesControllerTest < ActionController::TestCase
  setup do
    @serviice = serviices(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:serviices)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create serviice" do
    assert_difference('Serviice.count') do
      post :create, serviice: { code: @serviice.code, name: @serviice.name }
    end

    assert_redirected_to serviice_path(assigns(:serviice))
  end

  test "should show serviice" do
    get :show, id: @serviice
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @serviice
    assert_response :success
  end

  test "should update serviice" do
    patch :update, id: @serviice, serviice: { code: @serviice.code, name: @serviice.name }
    assert_redirected_to serviice_path(assigns(:serviice))
  end

  test "should destroy serviice" do
    assert_difference('Serviice.count', -1) do
      delete :destroy, id: @serviice
    end

    assert_redirected_to serviices_path
  end
end
