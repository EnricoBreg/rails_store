class Settings::UsersController < Settings::BaseController
  def show
  end

  def destroy
    if Current.user.admin?
      redirect_to settings_user_path, alert: "Admin users cannot delete their account." and return
    end
    terminate_session
    Current.user.destroy
    redirect_to root_path, notice: "Your account has been deleted."
  end
end
