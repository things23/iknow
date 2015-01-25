require_relative "../acceptance_helper"

feature "Delete question", %q{
  In order to fix my mistake
  As an user
  I want to be able to delete my questions
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }

  scenario "Authenticated user delete question" do
    sign_in(user)

    visit question_path(question)
    click_on "Delete"

    expect(page).to_not have_content "MyQuestion"
  end

  scenario "Authenticated user try to delete another users question" do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_link "Delete"
  end
end