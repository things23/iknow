require_relative "acceptance_helper"

feature "Delete question", %q{
  In order to fix my mistake
  As an user
  I want to be able to delete my questions
} do
  given(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }

  scenario "Authenticated user delete question" do
    sign_in(user)

    visit root_path
    click_on "MyQuestion"
    click_on "Delete"

    expect(page).to have_content "Question was successfully deleted"
    expect(current_path).to eq root_path
  end
end