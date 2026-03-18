class Settings::ProfilesController < Settings::BaseController
  before_action :set_user

  def show
  end

  def update
    if @user.update(profile_params)
      redirect_to settings_profile_path, status: :see_other, notice: "Your profile has been updated successfully"
    else
      render :show, status: :unprocessable_entity
    end
  end

  private
    def profile_params
      params.expect(user: [ :first_name, :last_name ])
    end

    def set_user
      @user = Current.user
    end
end
