require "rails_helper"

feature "Create question", %q{
  In order to get answer from community
  As an authenticated user
  I want to be able to ask questions
} do

  given(:user) { create(:user) }

  scenario "Authenticated user creates question" do
    sign_in(user)

    visit root_path
    click_on "Ask Question"
    fill_in "Title", with: "Test?"
    fill_in "Body", with: "textext"
    click_on "Create question"

    expect(page).to have_content "Question created"
    expect(current_path).to eq question_path(Question.last.id)
  end

  scenario "Non-authenticated user tries to create question " do
    visit new_question_path

    expect(page).to have_content "You need to sign in or sign up before continuing."
    expect(current_path).to eq new_user_session_path
  end
end