class SessionsController < ApplicationController
  require 'securerandom'
  require 'open-uri'
  require 'json'

  def new
    if (Rails.env.development? || ENV['ADPHI_IMPERSONATE']) && params[:as].present?
      brother = Brother.find_by(kerberos: params[:as])

      return redirect_to root_path, flash: {error: 'Cannot find brother with kerberos ' + params[:as]} if brother.nil?

      sign_in brother
      return redirect_back root_path, flash: {success: "Welcome, Brother #{brother.name}. "}
    end

    redirect_to 'https://jiahaoli.scripts.mit.edu:444/bitstation/authenticate/?auth_token=' + generate_auth_token
  end

  def authenticate
    token = params[:auth_token]

    check_link = 'http://jiahaoli.scripts.mit.edu/bitstation/check/?auth_token=' + token
    result = JSON.parse(open(check_link).read)

    if result && result["success"]
      brother = Brother.find_by(kerberos: result["kerberos"])

      if brother.nil?
        redirect_to sessions_fail_url(message: 'Your Kerberos ID does not seem to be a brother\'s')
      else
        sign_in brother
        redirect_back root_path, flash: {success: "Welcome, Brother #{brother.name}. "}
      end
    end
  end

  def fail
    flash[:alert] = params[:message]
    redirect_to root_path
  end

  def destroy
    if signed_in?
      sign_out
      flash[:success] = 'You have successfully signed out. '
    end

    redirect_to root_path
  end

  private

    def generate_auth_token
      SecureRandom.hex
    end
end
