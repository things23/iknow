require_relative "../acceptance_helper"

feature "Add a comment to question", %q{
  In order to get more info from the creator of question
  As an authenticated user
  I want to add a comment to the question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "add comment to the  question", js: true do
      within ".question" do
        click_on "add a comment"
        fill_in "Comment", with: "My comment"
        click_on "Add"
        expect(page).to_not have_selector "textarea"
      end

      within "#comments-question-#{question.id}" do
        expect(page).to have_content("My comment")
      end
    end
  end

  scenario "Non-athenticated user try to add comment to the question" do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_link("add a comment")
    end
  end
end