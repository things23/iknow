require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :attachments}
  it { should have_and_belong_to_many :subscribers }
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }


  describe ".subscribe" do
    let(:user) { create(:user) }
    let(:subscriber) { create(:user) }
    let(:question) { create(:question, user: user) }

    it "subscribe current_user to question" do
      question.subscribe(subscriber)
      question.reload

      expect(question.subscribers.last).to eq subscriber
    end

    it "change subscribers count" do

      expect { question.subscribe(subscriber) }.to change { question.subscribers.count }.by(1)
    end
  end
end
