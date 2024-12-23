class ApplicationController < ActionController::Base
  include DeviseTokenAuth::Concerns::SetUserByToken
  protect_from_forgery unless: -> { request.format.json? }
  layout :resolve_layout
  before_action :configure_sign_up_params, only: [:create], if: :devise_controller?
  before_action :configure_permitted_parameters, if: :devise_controller?

  private

  def resolve_layout
    if request.format.json?
      nil
    else
      "application"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: %w(nickname email last_name first_name project_id role))
  end

  def configure_sign_up_params = devise_parameter_sanitizer.permit(:sign_up, keys: %w[username role first_name last_name
                                                                    project_id email password password_confirmation])
end
