require 'rails_helper'

RSpec.describe Question, :type => :model do
  it { should have_many :answers }
  it { should have_many :comments }
  it { should have_many :attachments}
  it { should belong_to :user }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :attachments }

  describe ".set_best" do
    let(:user) { create(:user) }
    let!(:question) { create(:question, user: user) }
    it "set id of best answer to best_answer attribute" do
      @id = 1
      expect { question.set_best(@id) }.to change { question.best_answer }.to(1)
    end
  end
end
