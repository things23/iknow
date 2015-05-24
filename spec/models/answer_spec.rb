require 'rails_helper'

RSpec.describe Answer, :type => :model do
  it { should belong_to :question }
  it { should belong_to :user }
  it { should have_many :attachments }
  it { should have_many :comments }

  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe ".set_best" do
    let!(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    let!(:marked_answer) { create(:answer, best_answer: true, question: question, user: user) }
    let!(:answer) { create(:answer, question: question, user: user) }

    context "best answer was marked before" do

      it "sets attrribute best_answer for old best answer to false" do
        answer.set_best
        marked_answer.reload
        expect(marked_answer.best_answer).to be false
      end

      it "sets attribute best_answer for new best answer to be true" do
        expect { answer.set_best }.to change { answer.best_answer }.to be true
      end
    end

    context "best answer does not exist yet" do
      it "sets attribute best_answer for related answer to be true" do
        expect { answer.set_best }.to change { answer.best_answer }.to be true
      end

      it "sets attribute resolved for related question" do
        answer.set_best
        question.reload
        expect(question).to be_resolved
      end
    end
  end
end