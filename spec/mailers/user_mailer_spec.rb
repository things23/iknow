require "rails_helper"

RSpec.describe UserMailer, :type => :mailer do
  describe "question_answered" do
    let(:user) { create(:user) }
    let(:question) { create(:question, user: user) }
    let(:answer) { create(:answer, question: question, user: user) }
    let(:mail) { UserMailer.question_answered(user, answer) }


    it "renders the headers" do
      expect(mail.subject).to eq("Have answer to your question")
      expect(mail.to).to eq(["#{user.email}"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("You have new answer to your question")
    end

    it "renders the answer" do
      expect(mail.body.encoded).to match(answer.body)
    end
  end
end