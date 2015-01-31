require_relative "../acceptance_helper"

feature "Mark answer as best", %q{
  In order to mark best answer
  As an author of the question
  I want to be able to choose best answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  before do
    sign_in(user)
    visit question_path(question)
  end

  scenario "sees link to edit answer" do
    within ".answer" do
      expect(page).to have_link "Accept answer"
    end
  end

  scenario "Creator of the question can mark best answer", js: true do
    within ".answer" do
      click_on "Accept answer"
      expect(page).to have_content "Best answer ✓"
    end
  end

end