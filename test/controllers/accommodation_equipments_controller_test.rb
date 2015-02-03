require 'test_helper'

class AccommodationEquipmentsControllerTest < ActionController::TestCase
  setup do
    @accommodation_equipment = accommodation_equipments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:accommodation_equipments)
  end

  test "should get new_owner" do
    get :new_owner
    assert_response :success
  end

  test "should create accommodation_equipment" do
    assert_difference('AccommodationEquipment.count') do
      post :create, accommodation_equipment: { accommodation_id: @accommodation_equipment.accommodation_id, equipment_id: @accommodation_equipment.equipment_id }
    end

    assert_redirected_to accommodation_equipment_path(assigns(:accommodation_equipment))
  end

  test "should show accommodation_equipment" do
    get :show, id: @accommodation_equipment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @accommodation_equipment
    assert_response :success
  end

  test "should update accommodation_equipment" do
    patch :update, id: @accommodation_equipment, accommodation_equipment: { accommodation_id: @accommodation_equipment.accommodation_id, equipment_id: @accommodation_equipment.equipment_id }
    assert_redirected_to accommodation_equipment_path(assigns(:accommodation_equipment))
  end

  test "should destroy accommodation_equipment" do
    assert_difference('AccommodationEquipment.count', -1) do
      delete :destroy, id: @accommodation_equipment
    end

    assert_redirected_to accommodation_equipments_path
  end
end
