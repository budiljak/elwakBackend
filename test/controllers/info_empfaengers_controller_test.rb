require 'test_helper'

class InfoEmpfaengersControllerTest < ActionController::TestCase
  setup do
    @info_empfaenger = info_empfaengers(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:info_empfaengers)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create info_empfaenger" do
    assert_difference('InfoEmpfaenger.count') do
      post :create, info_empfaenger: { benutzer_id: @info_empfaenger.benutzer_id, gelesen: @info_empfaenger.gelesen, info_id: @info_empfaenger.info_id }
    end

    assert_redirected_to info_empfaenger_path(assigns(:info_empfaenger))
  end

  test "should show info_empfaenger" do
    get :show, id: @info_empfaenger
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @info_empfaenger
    assert_response :success
  end

  test "should update info_empfaenger" do
    patch :update, id: @info_empfaenger, info_empfaenger: { benutzer_id: @info_empfaenger.benutzer_id, gelesen: @info_empfaenger.gelesen, info_id: @info_empfaenger.info_id }
    assert_redirected_to info_empfaenger_path(assigns(:info_empfaenger))
  end

  test "should destroy info_empfaenger" do
    assert_difference('InfoEmpfaenger.count', -1) do
      delete :destroy, id: @info_empfaenger
    end

    assert_redirected_to info_empfaengers_path
  end
end
