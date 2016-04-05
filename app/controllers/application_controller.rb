class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  # Let only signed in users do anything.
  before_action :authenticate_user!

  # Permit additional params on sign up.
  before_action :configure_permitted_parameters, if: :devise_controller?

  protected

    def configure_permitted_parameters
      devise_parameter_sanitizer.for(:sign_up) do |u|
        u.permit(:email, :firstname, :lastname, :password, :password_confirmation)
      end
    end

    def requires_admin
      redirect_to root_path, flash: { error: 'Permission denied.' } unless current_user.admin?
    end
end
