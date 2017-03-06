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

    redirect_to 'https://oidc.mit.edu/authorize?' + {
      client_id: ENV['OPENID_CLIENT_ID'],
      response_type: 'code',
      scope: 'openid email profile',
      redirect_uri: openid_callback_url,
      state: session[:state],
      nonce: session[:nonce]
    }.to_query
  end

  def openid_callback
    return redirect_to root_path, flash: {error: 'No auth code received. ', sign_in_failed: true} unless params[:code].present?

    # Retrieving access token
    code = params[:code]
    post_params = {
      client_id: ENV['OPENID_CLIENT_ID'],
      client_secret: ENV['OPENID_CLIENT_SECRET'],
      grant_type: 'authorization_code',
      code: code,
      redirect_uri: openid_callback_url
    }
    result = Net::HTTP.post_form(URI.parse('https://oidc.mit.edu/token'), post_params)
    token = JSON.parse(result.body)

    return redirect_to root_path, flash: {error: 'Authorized scope does not include email. ', sign_in_failed: true} unless token['scope'].include? 'email'
    return redirect_to root_path, flash: {error: 'Authorized scope does not include profile. ', sign_in_failed: true} unless token['scope'].include? 'profile'

    # Retrieving user information
    uri = URI.parse('https://oidc.mit.edu/userinfo')
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request.initialize_http_header({
      'Authorization' => "Bearer #{token['access_token']}"
    })
    userinfo = JSON.parse(http.request(request).body)

    return redirect_to root_path, flash: {error: 'Cannot find Kerberos in the returned userinfo. ', sign_in_failed: true} unless userinfo['preferred_username'].present?

    kerberos = userinfo['preferred_username']
    brother = Brother.find_by(kerberos: kerberos)
    return redirect_to root_path, flash: {error: 'Cannot find brother with kerberos ' + params[:as] + '. '} if brother.nil?

    sign_in brother
    return redirect_back root_path, flash: {success: "Welcome, Brother #{brother.name}. "}
  end

  def fail
    flash[:alert] = params[:message]
    flash[:sign_in_failed] = true
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

    def openid_connect_client
      OpenIDConnect::Client.new(
        identifier: ENV['OPENID_CLIENT_ID'],
        secret: ENV['OPENID_CLIENT_SECRET'],
        redirect_uri: openid_callback_url,
        host: 'oidc.mit.edu',
        authorization_endpoint: '/oauth/authorize',
        token_endpoint: '/oauth/tokens',
        userinfo_endpoint: '/oauth/userinfo',
      )
    end
end
