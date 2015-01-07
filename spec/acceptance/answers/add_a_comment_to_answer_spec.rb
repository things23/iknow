require_relative "../acceptance_helper"

feature "Add a comment to answer", %q{
  In order to get more info from the creator of answer
  As an authenticated user
  I want to add a comment to the answe
} do

  given(:user) { create(:user) }
  given(:question) { create(:question, user: user) }
  given!(:answer) { create(:answer, user: user, question: question) }

  scenario "Athenticated user add comment to the  question", js: true do
    sign_in(user)
    visit question_path(question)

    within ".answers" do
      click_on "add a comment"
      fill_in "Comment", with: "My comment"
      click_on "Add"
    end

    expect(page).to have_content("My comment")
  end
  scenario "Non-athenticated user try to add comment to the question" do
    visit question_path(question)

    within ".question" do
      expect(page).to_not have_link("add a comment")
    end
  end
end