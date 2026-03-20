class Email::ConfirmationsController < ApplicationController
  allow_unauthenticated_access

  def show
    user = User.find_by_token_for(:email_confirmation, params[:token])
    if user&.confirm_email
      flash[:notice] = "Your email address has been verified successfully."
    else
      flash[:alert] = "The email confirmation link is invalid or has expired."
    end
    redirect_to root_path
  end
end
