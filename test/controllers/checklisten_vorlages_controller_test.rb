require 'test_helper'

class ChecklistenVorlagesControllerTest < ActionController::TestCase
  setup do
    @checklisten_vorlage = checklisten_vorlages(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checklisten_vorlages)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checklisten_vorlage" do
    assert_difference('ChecklistenVorlage.count') do
      post :create, checklisten_vorlage: { bezeichner: @checklisten_vorlage.bezeichner, inaktiv: @checklisten_vorlage.inaktiv, objekt_id: @checklisten_vorlage.objekt_id, position: @checklisten_vorlage.position, version: @checklisten_vorlage.version }
    end

    assert_redirected_to checklisten_vorlage_path(assigns(:checklisten_vorlage))
  end

  test "should show checklisten_vorlage" do
    get :show, id: @checklisten_vorlage
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @checklisten_vorlage
    assert_response :success
  end

  test "should update checklisten_vorlage" do
    patch :update, id: @checklisten_vorlage, checklisten_vorlage: { bezeichner: @checklisten_vorlage.bezeichner, inaktiv: @checklisten_vorlage.inaktiv, objekt_id: @checklisten_vorlage.objekt_id, position: @checklisten_vorlage.position, version: @checklisten_vorlage.version }
    assert_redirected_to checklisten_vorlage_path(assigns(:checklisten_vorlage))
  end

  test "should destroy checklisten_vorlage" do
    assert_difference('ChecklistenVorlage.count', -1) do
      delete :destroy, id: @checklisten_vorlage
    end

    assert_redirected_to checklisten_vorlages_path
  end
end
