class OmniauthCallbacksController < Devise::OmniauthCallbacksController
  def all
    @oauth = request.env['omniauth.auth']
    @user = User.find_for_oauth(@oauth)
    if @user.persisted?
      sign_in_and_redirect @user, event: :authentication
      set_flash_message(:notice, :success, kind: "#{@oauth.provider}") if is_navigational_format?
    end
  end
  alias_method :twitter, :all
  alias_method :facebook, :all
  #def twitter
    #return unless request.env['omniauth.auth']
  #  @oauth = request.env['omniauth.auth']
  #  @user = User.find_for_oauth_(@oauth)
  #  if @user.persisted?
  #    sign_in_and_redirect @user, event: :authentication
  #    set_flash_message(:notice, :success, kind: 'Twitter') if is_navigational_format?
  #  else
  #   session['devise.oauth'] = @oauth
  #   redirect_to new_user_registration_path
  # end
  #end
end