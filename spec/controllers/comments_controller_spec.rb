require 'rails_helper'

describe CommentsController do
  sign_in_user

  let(:question) { create(:question, user: @user) }

  describe "POST #create" do
    context "with valid attributes" do
      it "saves comment to database" do
        expect {
            post :create, question_id: question, comment: attributes_for(:comment), format: :js
          }.to change(Comment, :count).by(1)
      end
      it "render create template" do
      end
    end

    context "with invalid attributes" do
      it "does not save comment to the database" do
      end
      it "re-renders create template" do
      end
    end

  end
end