require_relative "../acceptance_helper"

feature "User sign out", %q{
  In order to destroy my sessions
  As an user
  I want to be able to sign out"
} do

  given(:user) { create(:user) }

  scenario "Logined user try to sign out" do
    sign_in(user)

    click_on "Sign out"

    expect(page).to have_content("Signed out successfully.")
    expect(current_path).to eq root_path

    visit new_question_path
    expect(current_path).to eq new_user_session_path
  end
end