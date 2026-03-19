class Settings::EmailsController < Settings::BaseController
  def show
  end

  def update
    user = Current.user
    if user.update(email_params)
      redirect_to settings_email_path, status: :see_other, notice: "Email updated successfully. We've sent a verification email to #{user.unconfirmed_email}"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private
    def email_params
      params.expect(user: [ :password_challenge, :unconfirmed_email ]).with_defaults(password_challenge: "")
    end
end
