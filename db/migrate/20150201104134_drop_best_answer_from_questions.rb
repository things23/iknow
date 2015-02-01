class DropBestAnswerFromQuestions < ActiveRecord::Migration
  def change
    remove_column :questions, :best_answer
  end
end
