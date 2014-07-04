require 'test_helper'

class WachbuchEintragsControllerTest < ActionController::TestCase
  setup do
    @wachbuch_eintrag = wachbuch_eintrags(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:wachbuch_eintrags)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create wachbuch_eintrag" do
    assert_difference('WachbuchEintrag.count') do
      post :create, wachbuch_eintrag: { ausruestung_funktion: @wachbuch_eintrag.ausruestung_funktion, ausruestung_vollzaehlig: @wachbuch_eintrag.ausruestung_vollzaehlig, besonderheiten: @wachbuch_eintrag.besonderheiten, schaeden: @wachbuch_eintrag.schaeden, schicht_id: @wachbuch_eintrag.schicht_id, schluessel_bemerkung: @wachbuch_eintrag.schluessel_bemerkung, schluessel_vollzaehlig: @wachbuch_eintrag.schluessel_vollzaehlig }
    end

    assert_redirected_to wachbuch_eintrag_path(assigns(:wachbuch_eintrag))
  end

  test "should show wachbuch_eintrag" do
    get :show, id: @wachbuch_eintrag
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @wachbuch_eintrag
    assert_response :success
  end

  test "should update wachbuch_eintrag" do
    patch :update, id: @wachbuch_eintrag, wachbuch_eintrag: { ausruestung_funktion: @wachbuch_eintrag.ausruestung_funktion, ausruestung_vollzaehlig: @wachbuch_eintrag.ausruestung_vollzaehlig, besonderheiten: @wachbuch_eintrag.besonderheiten, schaeden: @wachbuch_eintrag.schaeden, schicht_id: @wachbuch_eintrag.schicht_id, schluessel_bemerkung: @wachbuch_eintrag.schluessel_bemerkung, schluessel_vollzaehlig: @wachbuch_eintrag.schluessel_vollzaehlig }
    assert_redirected_to wachbuch_eintrag_path(assigns(:wachbuch_eintrag))
  end

  test "should destroy wachbuch_eintrag" do
    assert_difference('WachbuchEintrag.count', -1) do
      delete :destroy, id: @wachbuch_eintrag
    end

    assert_redirected_to wachbuch_eintrags_path
  end
end
