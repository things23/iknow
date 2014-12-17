require 'rails_helper'

feature "User sign up", %q{
  In order to be able to ask question
  As an guest
  I want to be able to sign up
} do

  #given(:user) { create(:user) }

  scenario "Guest try to sign ip" do
    #sign_in(user)
    visit root_path
    click_on "Sign up"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "12341234"
    fill_in "Password confirmation", with: "12341234"
    click_on "Create account"
    expect(current_path).to eq root_path
  end
end