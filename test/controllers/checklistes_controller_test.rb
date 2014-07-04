require 'test_helper'

class ChecklistesControllerTest < ActionController::TestCase
  setup do
    @checkliste = checklistes(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:checklistes)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create checkliste" do
    assert_difference('Checkliste.count') do
      post :create, checkliste: { checklisten_vorlage_id: @checkliste.checklisten_vorlage_id, position: @checkliste.position, schicht_id: @checkliste.schicht_id, uhrzeit: @checkliste.uhrzeit }
    end

    assert_redirected_to checkliste_path(assigns(:checkliste))
  end

  test "should show checkliste" do
    get :show, id: @checkliste
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @checkliste
    assert_response :success
  end

  test "should update checkliste" do
    patch :update, id: @checkliste, checkliste: { checklisten_vorlage_id: @checkliste.checklisten_vorlage_id, position: @checkliste.position, schicht_id: @checkliste.schicht_id, uhrzeit: @checkliste.uhrzeit }
    assert_redirected_to checkliste_path(assigns(:checkliste))
  end

  test "should destroy checkliste" do
    assert_difference('Checkliste.count', -1) do
      delete :destroy, id: @checkliste
    end

    assert_redirected_to checklistes_path
  end
end
