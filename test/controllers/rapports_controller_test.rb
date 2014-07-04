require 'test_helper'

class RapportsControllerTest < ActionController::TestCase
  setup do
    @rapport = rapports(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:rapports)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create rapport" do
    assert_difference('Rapport.count') do
      post :create, rapport: { beschreibung: @rapport.beschreibung, massnahmen: @rapport.massnahmen, ort: @rapport.ort, position: @rapport.position, schicht_id: @rapport.schicht_id, uhrzeit: @rapport.uhrzeit }
    end

    assert_redirected_to rapport_path(assigns(:rapport))
  end

  test "should show rapport" do
    get :show, id: @rapport
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @rapport
    assert_response :success
  end

  test "should update rapport" do
    patch :update, id: @rapport, rapport: { beschreibung: @rapport.beschreibung, massnahmen: @rapport.massnahmen, ort: @rapport.ort, position: @rapport.position, schicht_id: @rapport.schicht_id, uhrzeit: @rapport.uhrzeit }
    assert_redirected_to rapport_path(assigns(:rapport))
  end

  test "should destroy rapport" do
    assert_difference('Rapport.count', -1) do
      delete :destroy, id: @rapport
    end

    assert_redirected_to rapports_path
  end
end
