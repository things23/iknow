require_relative "../acceptance_helper"

feature "Edit answer", %q{
  In order to fix mistakes in my answers
  As an author of answer
  I want to be able to edit my answers
} do
  given(:user) { create(:user) }
  given(:another_user) { create(:user)}
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe "Authenticated user" do

    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "sees link to edit answer" do
      within ".answer" do
        expect(page).to have_link "Edit"
      end
    end

    scenario "try to edit question", js: true do
      within ".answer" do
        click_on "Edit"
        fill_in "Answer", with: "yes edit"
        click_on "Save"

        expect(page).to_not have_content answer.body
        expect(page).to_not have_selector "textarea"
        expect(page).to have_content "yes edit"
      end
    end
  end

  scenario "Another authenticated user try to edit other user's answer " do
    sign_in(another_user)
    visit question_path(question)
    within ".answer" do
      expect(page).to_not have_link("Edit")
    end
  end

  scenario "Non-authenticated user try to edit answer " do
    visit question_path(question)

    within ".answer" do
      expect(page).to_not have_link("Edit")
    end
  end
end