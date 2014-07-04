require 'test_helper'

class ObjektsControllerTest < ActionController::TestCase
  setup do
    @objekt = objekts(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:objekts)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create objekt" do
    assert_difference('Objekt.count') do
      post :create, objekt: { bezeichner: @objekt.bezeichner, inaktiv: @objekt.inaktiv }
    end

    assert_redirected_to objekt_path(assigns(:objekt))
  end

  test "should show objekt" do
    get :show, id: @objekt
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @objekt
    assert_response :success
  end

  test "should update objekt" do
    patch :update, id: @objekt, objekt: { bezeichner: @objekt.bezeichner, inaktiv: @objekt.inaktiv }
    assert_redirected_to objekt_path(assigns(:objekt))
  end

  test "should destroy objekt" do
    assert_difference('Objekt.count', -1) do
      delete :destroy, id: @objekt
    end

    assert_redirected_to objekts_path
  end
end
