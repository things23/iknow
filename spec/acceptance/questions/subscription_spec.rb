require_relative "../acceptance_helper"

feature "Subscribe to question", %q{
  In order to stay in touch and see new answers
  As an authenticated user
  I want to be able to subcribe to question
} do

  given(:user) { create(:user) }
  given!(:question) { create(:question, user: user) }

  describe "Authenticated user" do
    before do
      sign_in(user)
      visit question_path(question)
    end
    scenario "have link", js: true do
      within ".question" do
        expect(page).to have_link "subscribe"
      end
    end

    scenario "add comment to the  question", js: true do
      within ".question" do
        click_on "subscribe"
        expect(page).to have_css('.subscribed')
      end
    end
  end

  scenario "Non-athenticated user try to add comment to the question" do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_link("subscribe")
    end
  end
end