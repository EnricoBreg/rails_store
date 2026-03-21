require "test_helper"

class Email::ConfirmationsControllerTest < ActionDispatch::IntegrationTest
  # Test no. 1
  # Questo test verifica che se viene fornito un token non valido, l'email dell'utente
  # non deve di conseguenza essere aggiornata, e deve essere restituito un messaggio
  # di errore che indica che il link di conferma è invalido o è scaduto.
  # Inoltre, viene anche verificato che l'email dell'utente non venga effettivamente
  # aggiornata, e rimanga uguale a quella precedente.
  test "invalid token are ignored" do
    user = users(:one)
    previous_email = user.email_address
    user.update(unconfirmed_email: "new@example.com")
    get email_confirmation_path(token: "invalid")
    # assert_equal "Invalid token.", flash[:alert]
    assert_equal "The email confirmation link is invalid or has expired.", flash[:alert]
    user.reload
    assert_equal previous_email, user.email_address
  end

  # Test no. 2
  # Questo test verifica se viene fornita un token valido. L'email dell'utente deve
  # essere aggiornata con successo usando la nuova email non confermata, e deve essere
  # restituito un messaggio di successo che indica che l'indirizzo email è stato verificato
  # con successo. Inoltre, viene anche verificato che l'attributo :unconfirmed_email dell'utente
  # venga azzerato (nil) dopo la conferma, e che l'email dell'utente sia effettivamente aggiornata
  # con la nuova email inserita in :unconfirmed_email.
  test "email is updated with a valid token" do
    user = users(:one)
    user.update(unconfirmed_email: "new@example.com")
    get email_confirmation_path(token: user.generate_token_for(:email_confirmation))
    assert_equal "Your email address has been verified successfully.", flash[:notice]
    user.reload
    assert_equal "new@example.com", user.email_address
    assert_nil user.unconfirmed_email
  end
end
