require "rails_helper"

feature "Edit answer", %q{
  In order to fix mistakes in my answers
  As an user
  I want to be able to edit my answers
} do
  given(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }
  let!(:answer) { create(:answer, user_id: user.id, question_id: question.id) }

  scenario "Authenticated user edit question" do
    sign_in(user)

    visit question_path(question)
    click_on "Edit Answer"
    fill_in "Body", with: "yes edit"
    click_on "Save changes"

    expect(page).to have_content "Answer was successfully updated"
    expect(current_path).to eq question_path(question)
  end

  scenario "Non-authenticated user tries to endit answer " do
    visit edit_answer_path(answer)

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(current_path).to eq new_user_session_path
  end
end