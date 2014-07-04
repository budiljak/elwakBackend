require 'test_helper'

class SchichtsControllerTest < ActionController::TestCase
  setup do
    @schicht = schichts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:schichts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create schicht" do
    assert_difference('Schicht.count') do
      post :create, schicht: { benutzer_id: @schicht.benutzer_id, datum: @schicht.datum, objekt_id: @schicht.objekt_id, uhrzeit_beginn: @schicht.uhrzeit_beginn, uhrzeit_ende: @schicht.uhrzeit_ende }
    end

    assert_redirected_to schicht_path(assigns(:schicht))
  end

  test "should show schicht" do
    get :show, id: @schicht
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @schicht
    assert_response :success
  end

  test "should update schicht" do
    patch :update, id: @schicht, schicht: { benutzer_id: @schicht.benutzer_id, datum: @schicht.datum, objekt_id: @schicht.objekt_id, uhrzeit_beginn: @schicht.uhrzeit_beginn, uhrzeit_ende: @schicht.uhrzeit_ende }
    assert_redirected_to schicht_path(assigns(:schicht))
  end

  test "should destroy schicht" do
    assert_difference('Schicht.count', -1) do
      delete :destroy, id: @schicht
    end

    assert_redirected_to schichts_path
  end
end
