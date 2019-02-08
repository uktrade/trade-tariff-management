class SessionsController < ActionController::Base

  include AuthHelper

  # this is the SSO callback
  def create

    logger.debug "In SessionsController#create"
    auth = request.env['omniauth.auth']

    if auth.uid.nil? || auth.uid.blank? ||
        auth.info.email.nil? || auth.info.email.blank? ||
        auth.info.first_name.nil? || auth.info.first_name.blank? ||
        auth.info.last_name.nil? || auth.info.last_name.blank?

      logger.debug "Unable to process callback due to missing data"
      redirect_to root_url

    else

      session[:userinfo] = User.from_omniauth(auth)    # will create if doesn't exist
      session[:auth] = auth

      logger.debug "user.name = '" + session[:userinfo].name + "'"
      logger.debug "user.id = '" + session[:userinfo].id.to_s + "'"
      logger.debug session[:userinfo]

      # for debug - can remove...
      @details = auth       # @details for view - remove redirect to test...
      logger.debug "email: " + @details["info"]["email"].to_s

      if @details["credentials"].present?
        logger.debug "token: " + @details["credentials"]["token"].to_s
        logger.debug "refresh: " + @details["credentials"]["refresh_token"].to_s
        logger.debug "expires: " + @details["credentials"]['expires_at'].to_s
      end

      redirect_to root_url

    end

  end

  # handle logout or unauthorised/access disabled
  def destroy

    session[:userinfo] = nil
    session[:auth] = nil

    if params[:disabled]
      logger.debug "?disabled=something"
      @title = "Unauthorised"
      @message = "Your user account is not authorised to use this application."
      @additional = "Please contact the application administrator to arrange access."

      # Don't redirect to root url otherwise, the authentication sequence will restart
      # Therefore the default view for destroy will just show a 'you are logged out page'

    else
      redirect_to logout_path
    end

  end

end
