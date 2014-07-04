require 'test_helper'

class KontrollanrufsControllerTest < ActionController::TestCase
  setup do
    @kontrollanruf = kontrollanrufs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kontrollanrufs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kontrollanruf" do
    assert_difference('Kontrollanruf.count') do
      post :create, kontrollanruf: { bemerkung: @kontrollanruf.bemerkung, objekt: @kontrollanruf.objekt, position: @kontrollanruf.position, uhrzeit: @kontrollanruf.uhrzeit, wachbuch_eintrag_id: @kontrollanruf.wachbuch_eintrag_id }
    end

    assert_redirected_to kontrollanruf_path(assigns(:kontrollanruf))
  end

  test "should show kontrollanruf" do
    get :show, id: @kontrollanruf
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kontrollanruf
    assert_response :success
  end

  test "should update kontrollanruf" do
    patch :update, id: @kontrollanruf, kontrollanruf: { bemerkung: @kontrollanruf.bemerkung, objekt: @kontrollanruf.objekt, position: @kontrollanruf.position, uhrzeit: @kontrollanruf.uhrzeit, wachbuch_eintrag_id: @kontrollanruf.wachbuch_eintrag_id }
    assert_redirected_to kontrollanruf_path(assigns(:kontrollanruf))
  end

  test "should destroy kontrollanruf" do
    assert_difference('Kontrollanruf.count', -1) do
      delete :destroy, id: @kontrollanruf
    end

    assert_redirected_to kontrollanrufs_path
  end
end
