require "rails_helper"

feature "Create answer", %q{
  In order to help member of community to solve problem
  As an user
  I want to be able to create answer
} do

  given(:user) { create(:user) }
  let!(:question) { create(:question, user_id: user.id) }

  scenario "Authenticated user create answer" do
    sign_in(user)

    visit question_path(question)
    click_on "Your Answer"
    fill_in "Body", with: "Body"
    click_on "Post Your Answer"

    expect(page).to have_content "Answer was successfully created"
    expect(current_path).to eq question_path(question)
  end

  scenario "Non-authenticated user tries to create answer " do
    visit new_question_answer_path(question)

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(current_path).to eq new_user_session_path
  end
end