require_relative "acceptance_helper"

feature "Edit answer", %q{
  In order to fix mistakes in my questions
  As an user
  I want to be able to edit my questions
} do
  given(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }

  scenario "Authenticated user edit question" do
    sign_in(user)

    visit root_path
    click_on "MyQuestion"
    click_on "Edit"
    fill_in "Title", with: "Edit test?"
    fill_in "Body", with: "yes edit"
    click_on "Save changes"

    expect(page).to have_content "Question was successfully updated"
    expect(current_path).to eq question_path(question)
  end
end