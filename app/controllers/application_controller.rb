class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :store_location
  before_action :auto_sign_in

  AUTO_SIGN_IN_EXCEPTIONS = [
    /sessions#.*/,
    /kitchen#current_late_dinners/,
    /vouchers#export/
  ]

  private

    # Redirect logic

    def store_location
      session[:return_to] = request.fullpath if request.get? and controller_name != "sessions"
    end

    def redirect_back(default = root_url, params)
      redirect_to(session[:return_to] || default, params)
    end

    # Authentication

    def require_signed_in
      unless signed_in?
        redirect_back root_url, flash: {alert: 'You need to be signed in. '}
      end
    end

    def auto_sign_in
      return if AUTO_SIGN_IN_EXCEPTIONS.any? { |r| r =~ "#{self.controller_name}##{self.action_name}" }

      unless signed_in? || flash[:sign_in_failed]
        redirect_to sign_in_path
      end
    end

    # Sign in

    def current_brother
      begin
        @current_brother ||= (session[:brother_id] && Brother.find(session[:brother_id]))
      rescue ActiveRecord::RecordNotFound
        nil
      end
    end

    def sign_in(brother)
      session[:brother_id] = brother.id
    end

    def signed_in?
      current_brother != nil
    end

    def sign_out
      session[:brother_id] = nil
    end

    helper_method :current_brother, :signed_in?

    # Cancan related

    def current_ability
      @current_ability ||= Ability.new(current_brother)
    end

    rescue_from CanCan::AccessDenied do |e|
      redirect_to root_url, flash: {alert: e.message }
    end
end
