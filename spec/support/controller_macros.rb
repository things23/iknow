module ControllerMacros
  def sign_in_user
    before do
      @user = create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @user
    end
  end

  def sign_in_another_user
    before do
      @another_user = create(:user)
      @request.env["devise.mapping"] = Devise.mappings[:user]
      sign_in @another_user
    end
  end
end