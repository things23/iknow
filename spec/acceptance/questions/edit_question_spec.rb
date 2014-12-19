require_relative "../acceptance_helper"

feature "Edit answer", %q{
  In order to fix mistakes in my questions
  As an user
  I want to be able to edit my questions
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  scenario "Authenticated user edit question", js: true do
    sign_in(user)

    visit question_path(question)
    click_on "Edit"
    fill_in "Title", with: "Edit test?"
    fill_in "Body", with: "yes edit"
    click_on "Save changes"

    expect(page).to_not have_content("MyQuestion")
    expect(page).to_not have_content("Body of my question")
    expect(page).to have_content("Edit test?")
    expect(page).to have_content("yes edit")
  end

  scenario "Authenticated user try to delete another users question" do
    sign_in(another_user)

    visit question_path(question)

    expect(page).to_not have_link "Edit"
  end
end