require "test_helper"

class Settings::EmailsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  # Test no. 1
  # Questo test serve per verificare la validazione della password corrente quando
  # un utente cerca di aggiornare la propria email. Se la password fornita è errata,
  # l'aggiornamento dell'email non deve avvenire, e deve essere resituito un errore di
  # validazione (422 Unprocessable Entity).
  # Inoltre, non deve esere inviata nessuna email di conferma per la nuova email inserita.
  test "validates current password" do
    user = users(:one)
    sign_in_as user
    patch settings_email_path, params: { user: { password_challenge: "invalid_password", unconfirmed_email: "newemail@exampe.com" } }
    assert_response :unprocessable_entity # la validazione deve fallire e restituire un errore 422
    assert_nil user.reload.unconfirmed_email # unconfirmed_email deve essere nil
    assert_no_emails # non deve essere inviata nessuna email di conferma per la nuova email
  end

  # Test no. 2
  # Questo test, esegue la verifica contraria del Test no. 1. Cioè verifica che la password corrente
  # sia valida, viene rendirizzato l'utente, la mail non ancora confermata (:unconfirmed_email) è uguale
  # a quella inserita nella richiesta di update ed, infine, viene verificato che UserMail abbia in coda
  # la mail di da inviare al nuovo indirizzo inserito per la conferma.
  test "sends email confirmation on successful update" do
    user = users(:one)
    sign_in_as user
    patch settings_email_path, params: { user: { password_challenge: "password", unconfirmed_email: "new@example.com" } }
    assert_response :redirect
    assert_equal "new@example.com", user.reload.unconfirmed_email
    assert_enqueued_email_with UserMailer, :email_confirmation, params: { user: user }
  end
end
