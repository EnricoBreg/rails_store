require "test_helper"

class SettingsTest < ActionDispatch::IntegrationTest
  # Test no. 1
  # Questo test verifica che un utente normale (senza permessi di amministratore) veda correttamente
  # la sezione delle impostazioni del proprio profilo (verifica fatta tramite l'assert_dom) e che
  # non abbia accesso alla sezione delle impostazioni dello store, che è una sezione
  # riservata ai soli utenti admin (veritica fatta tramite l'assert_not_dom).
  test "user settings navigation" do
    sign_in_as users(:one)
    get settings_profile_path
    assert_dom "h4", "Account Settings"
    assert_not_dom "h4", "Store Settings"
  end

  # Test no. 2
  # Questo test verifica che un utente con permessi di amministratore veda correttamente la sezione
  # delle impostazioni del profilo e che, nella pagina, sia presente anche la sezione delle impostazioni
  # dello store, sezione che è riservata ai soli utenti admin.
  test "admin settings navigation" do
    sign_in_as users(:admin)
    get settings_profile_path
    assert_dom "h4", "Account Settings"
    assert_dom "h4", "Store Settings"
  end

  # Test no. 3
  # Questo test verifica che un utente senza permessi di amministratore non possa accedere alla sezione
  # delle impostazioni per i prodotti dello store, sezione riserva ai soli utente amministratori.
  # Il test simula l'accesso alla pagina /store/products da parte di un utente normale e verifica
  # che la risposta sia un errore di tipo "forbidden" (403) e che venga mostrato un messaggio di avviso.
  test "regular user cannot access /store/products" do
    sign_in_as users(:one)
    get store_products_path
    assert_response :forbidden
    assert_equal "You aren't allowed to do that.", flash[:alert]
  end

  # Test no. 4
  # Questo test è analogo al test no. 3, ma verifica che un utente normale non possa accedere alla
  # sezione delle impostazioni per gli utenti dello store, sezione riserva ai soli utente amministratori.
  test "regular user cannot access /store/users" do
    sign_in_as users(:one)
    get store_users_path
    assert_response :forbidden
    assert_equal "You aren't allowed to do that.", flash[:alert]
  end

  # Test no. 5
  # Questo test verifica che gli utenti con permessi di amministratore siano autorizzati ad accedere
  # alla sezione dedicata alla visualizzazione/modifica dei prodotti dello store.
  test "admins can access /store/products" do
    sign_in_as users(:admin)
    get store_products_path
    assert_response :success
  end

  # Test no. 6
  # Questo test, analogo al test no. 5, verifica che gli utenti con permessi di amministratore siano
  # autorizzati ad accedere alla sezione dedicata alla visualizzazione/modifica degli utenti dello store.
  test "admins can access /store/users" do
    sign_in_as users(:admin)
    get store_users_path
    assert_response :success
  end
end
