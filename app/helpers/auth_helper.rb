module AuthHelper
  private

  # Is the user signed in?
  # @return [Boolean]
  def user_signed_in?
    !current_user.nil?
  end

  # Has the SSO auth token expired?
  # @return [Boolean]
  def token_expired?

    if session[:auth].credentials.nil? || session[:auth].credentials.expires_at.nil?
      false
    else
      session[:auth].credentials.expires_at < Time.now.to_i
    end

  end

  # Authenticate a user
  # - redirects to login page if not signed in or expired session
  # - redirects to error page if user access is disabled
  def authenticate_user!
    if user_signed_in?
      # logger.debug "user signed in"
      # logger.debug session[:auth].info.email

      if token_expired?
        logger.debug "token expired"
        redirect_to login_path
      end
      if current_user.disabled?
        logger.debug "user access is disabled"
        redirect_to disabled_user_path
      end
    else
      logger.debug "user not signed in"
      redirect_to login_path
    end

  end

  # User record is held in the session variable
  def current_user
    if session[:userinfo]
      @current_user ||= session[:userinfo]
    end
  end


  # The login page depends on the authentication provider [ditsso internal or the omniauth developer]
  def login_path

    if ENV['DITSSO_INTERNAL_PROVIDER'].present?
      '/auth/ditsso_internal/'
    else
      '/auth/developer/'
    end

  end

  def logout_path

    if ENV['DITSSO_LOGOUT_URL'].present?
      ENV['DITSSO_LOGOUT_URL']
    end

  end

  # @return the path to the disabled message page
  def disabled_user_path
    '/logout?disabled=1'
  end

end