require 'test_helper'

class RoomEquipmentsControllerTest < ActionController::TestCase
  setup do
    @room_equipment = room_equipments(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:room_equipments)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create room_equipment" do
    assert_difference('RoomEquipment.count') do
      post :create, room_equipment: { equipment_id: @room_equipment.equipment_id, room_id: @room_equipment.room_id }
    end

    assert_redirected_to room_equipment_path(assigns(:room_equipment))
  end

  test "should show room_equipment" do
    get :show, id: @room_equipment
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @room_equipment
    assert_response :success
  end

  test "should update room_equipment" do
    patch :update, id: @room_equipment, room_equipment: { equipment_id: @room_equipment.equipment_id, room_id: @room_equipment.room_id }
    assert_redirected_to room_equipment_path(assigns(:room_equipment))
  end

  test "should destroy room_equipment" do
    assert_difference('RoomEquipment.count', -1) do
      delete :destroy, id: @room_equipment
    end

    assert_redirected_to room_equipments_path
  end
end
