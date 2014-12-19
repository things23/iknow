require_relative "../acceptance_helper"

feature "Delete answer", %q{
  In order to fix my mistake
  As an user
  I want to be able to delete my answer
} do
  given(:user) { create(:user) }
  given(:question) { create(:question, user_id: user.id) }
  given!(:answer) { create(:answer, user_id: user.id, question_id: question.id) }

  scenario "Authenticated user delete question" do
    sign_in(user)

    visit question_path(question)
    within ".answers" do
      click_on "Delete"
    end
    # проверить отсутствие удаленнгго ответа
    expect(page).to_not have_content "MyText"
    expect(page).to have_content "Answer was successfully deleted"
  end
end