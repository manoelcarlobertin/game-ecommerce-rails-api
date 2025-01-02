# app/controllers/application_controller.rb

class ApplicationController < ActionController::API
  before_action :configure_permitted_parameters, if: :devise_controller?

  def home
    render plain: "Bem-vindo à sua aplicação Rails!"
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name, :email, :password, :password_confirmation])
  end
end