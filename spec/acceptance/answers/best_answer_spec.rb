require_relative "../acceptance_helper"

feature "Mark answer as best", %q{
  In order to mark best answer
  As an author of the question
  I want to be able to choose best answer
} do
  given!(:user) { create(:user) }
  given!(:another_user) { create(:user) }
  given!(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  describe "Author of question" do
    before do
      sign_in(user)
      visit question_path(question)
    end

    scenario "sees link to accept answer" do
      within ".answer" do
        #save_and_open_page
        expect(page).to have_link "Accept answer"
      end
    end

    scenario "Creator of the question can mark best answer", js: true do
      within '.answer' do
        click_on "Accept answer"
        expect(page).to have_css('.marked-best')
      end
    end
  end

  describe "Just authenticated user, not author of question" do
    before do
      sign_in(another_user)
      visit question_path(question)
    end

    scenario "does not see link to accept answer" do
      within ".answer" do
        expect(page).to_not have_link "Accept answer"
      end
    end
  end

  describe "Not authenticated user" do
    before { visit question_path(question) }
    scenario "does not see link to accept answer" do
      within ".answer" do
        expect(page).to_not have_link "Accept answer"
      end
    end
  end
end