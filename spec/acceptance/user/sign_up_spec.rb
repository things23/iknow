require_relative "../acceptance_helper"

feature "User sign up", %q{
  In order to be able to ask question
  As an guest
  I want to be able to sign up
} do

  scenario "Guest try to sign ip" do
    visit root_path

    click_on "Sign up"
    fill_in "Email", with: "test@example.com"
    fill_in "Password", with: "12341234"
    fill_in "Password confirmation", with: "12341234"

    click_on "Create account"
    expect(current_path).to eq root_path

    visit new_question_path
    expect(current_path).to eq new_question_path
  end
end