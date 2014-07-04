require 'test_helper'

class KontrollgangsControllerTest < ActionController::TestCase
  setup do
    @kontrollgang = kontrollgangs(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:kontrollgangs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create kontrollgang" do
    assert_difference('Kontrollgang.count') do
      post :create, kontrollgang: { bemerkung: @kontrollgang.bemerkung, position: @kontrollgang.position, uhrzeit: @kontrollgang.uhrzeit, wachbuch_eintrag_id: @kontrollgang.wachbuch_eintrag_id }
    end

    assert_redirected_to kontrollgang_path(assigns(:kontrollgang))
  end

  test "should show kontrollgang" do
    get :show, id: @kontrollgang
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @kontrollgang
    assert_response :success
  end

  test "should update kontrollgang" do
    patch :update, id: @kontrollgang, kontrollgang: { bemerkung: @kontrollgang.bemerkung, position: @kontrollgang.position, uhrzeit: @kontrollgang.uhrzeit, wachbuch_eintrag_id: @kontrollgang.wachbuch_eintrag_id }
    assert_redirected_to kontrollgang_path(assigns(:kontrollgang))
  end

  test "should destroy kontrollgang" do
    assert_difference('Kontrollgang.count', -1) do
      delete :destroy, id: @kontrollgang
    end

    assert_redirected_to kontrollgangs_path
  end
end
