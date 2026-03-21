require "test_helper"

class SignUpsControllerTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end

  test "view sign up" do
    get sign_up_path
    assert_response :success
  end

  test "view sign up when authenticated" do
    sign_in_as users(:one)
    get sign_up_path
    assert_redirected_to root_path
  end

  test "successful sign up" do
    assert_difference "User.count" do
      post sign_up_path, params: { user: {
        first_name: "Example", last_name: "User", email_address: "example@example.com",
        password: "password", password_confirmation: "password" } }
      assert_redirected_to root_path
    end
  end

  # Da documentazione ufficiale di Rails: https://guides.rubyonrails.org/sign_up_and_settings.html#adding-tests
  #   This test should be invalid because the user's name is missing.
  #   Since this request is invalid, we need to assert the response is a 422 Unprocessable Entity.
  #   We can also assert that there is no difference in the User.count to ensure no User was created.
  test "invalid sign up" do
    assert_no_difference "User.count" do
      post sign_up_path, params: { user: {
        email_address: "example@example.com", password: "password", password_confirmation: "password"
      } }
      assert_response :unprocessable_entity
    end
  end

  # Lo scopo di questo test è assicurarsi che un utente non possa creare un account
  # con l'attributo admin impostato a true al momento del sign up.
  # Se questo test fallisce, allora esiste una vulnerabilità di sicurezza che permette a
  # chiunque di creare una account admin semplicemente includendo l'attributo nei parametri del sign up.
  test "sign up ignores admin attribute" do
    # Si crea un nuovo utente passando l'attributo admin: true eni parametri del sign-up.
    # Durante la procedura di creazione dell'utente, il controller dovrebbe, quindi, ignorare
    # l'attributo e creare un nuovo utente senza il flag di admin impostato a true.    #
    assert_difference "User.count" do
      post sign_up_path, params: { user: {
        first_name: "Example", last_name: "User", email_address: "example@example.com",
        password: "password", password_confirmation: "password", admin: true
      } }
      assert_redirected_to root_path
    end
    # Dopo l'effettiva creazione dell'utente, si verifica che l'attributo admin non sia stato impostato a true,
    # garantendo coì la sicurezza dell'applicazione contro la creazione di account admin non autorizzati.
    refute User.find_by(email_address: "example@example.com").admin?
  end
end
