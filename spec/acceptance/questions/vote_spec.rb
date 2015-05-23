=begin
require_relative "../acceptance_helper"

feature "Vote for the question", %q{
  In order to encourage interesting question
  As an authenticated user
  I want to vote for the question_path
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "vote up for the  question", js: true do
      within ".question" do
        click_on "Up"
        expect(page).to have_content "voted"
      end
    end

    scenario "vote down for the  question", js: true do
      within ".question" do
        click_on "Up"
        expect(page).to have_content "voted"
      end
    end
  end

  scenario "Non-athenticated user try to vote for the question" do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_link("Up")
      expect(page).to_not have_link("Down")
    end
  end
end
=end