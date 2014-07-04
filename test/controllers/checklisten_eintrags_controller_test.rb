require 'test_helper'

class ChecklistenEintragsControllerTest < ActionController::TestCase
  setup do
    @checklisten_eintrag = checklisten_eintrags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checklisten_eintrags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checklisten_eintrag" do
    assert_difference('ChecklistenEintrag.count') do
      post :create, checklisten_eintrag: { bezeichner: @checklisten_eintrag.bezeichner, checklisten_vorlage_id: @checklisten_eintrag.checklisten_vorlage_id, position: @checklisten_eintrag.position, typ: @checklisten_eintrag.typ, wann: @checklisten_eintrag.wann, was: @checklisten_eintrag.was }
    end

    assert_redirected_to checklisten_eintrag_path(assigns(:checklisten_eintrag))
  end

  test "should show checklisten_eintrag" do
    get :show, id: @checklisten_eintrag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @checklisten_eintrag
    assert_response :success
  end

  test "should update checklisten_eintrag" do
    patch :update, id: @checklisten_eintrag, checklisten_eintrag: { bezeichner: @checklisten_eintrag.bezeichner, checklisten_vorlage_id: @checklisten_eintrag.checklisten_vorlage_id, position: @checklisten_eintrag.position, typ: @checklisten_eintrag.typ, wann: @checklisten_eintrag.wann, was: @checklisten_eintrag.was }
    assert_redirected_to checklisten_eintrag_path(assigns(:checklisten_eintrag))
  end

  test "should destroy checklisten_eintrag" do
    assert_difference('ChecklistenEintrag.count', -1) do
      delete :destroy, id: @checklisten_eintrag
    end

    assert_redirected_to checklisten_eintrags_path
  end
end
