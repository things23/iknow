require "rails_helper"

feature "Delete answer", %q{
  In order to fix my mistake
  As an user
  I want to be able to delete my answer
} do
  given(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }
  let!(:answer) { create(:answer, user_id: user.id, question_id: question.id) }

  scenario "Authenticated user delete question" do
    sign_in(user)

    visit question_path(question)
    click_on "Delete Answer"

    expect(page).to have_content "Answer was successfully deleted"
    expect(current_path).to eq question_path(question)
  end
end