class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :update_sanitized_params, if: :devise_controller?
  before_filter :authenticate_user!
  before_filter :set_global_locale
  before_filter :check_deactivation

  autocomplete :user, :nom, :full => true
  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, :alert => exception.message
  end

  

  

  private
  def update_sanitized_params
    devise_parameter_sanitizer.for(:sign_up) { |u| u.permit(:email, :password, :password_confirmation, :d_adresse, :nom, :prenom, :picture_url, :ident_sexe, :promo, :ident_date_naissance, :ident_nationalite, :role, :active, :about, :ident_activite, :industry, :occupation) }
  end

  private
  def set_global_locale
     I18n.locale = :fr
  end 

  def check_deactivation
    if current_user.present? && current_user.active == false
      unless current_user.role == "admin"
        sign_out_and_redirect(user) 
      end
    end
  end 
  
end
