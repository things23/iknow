require_relative "../acceptance_helper"

feature "Create answer", %q{
  In order to help a member of community to solve problem
  As an user
  I want to be able to create answer
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user_id: user.id) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "create answer", js: true do
      fill_in "Your Answer", with: "My answer"
      click_on "Post Your Answer"

      within ".answers" do
        expect(page).to have_content "My answer"
      end
    end

    scenario "User try to create invalid answer", js: true do
      click_on "Post Your Answer"
      within ".answer-errors" do
        expect(page).to have_content "Body can't be blank"
      end
    end
  end

  scenario "Non-authenticated user tries to create answer " do
    visit question_path(question)
    within ".answers" do
      expect(page).to_not have_selector "textarea"
    end
  end
end