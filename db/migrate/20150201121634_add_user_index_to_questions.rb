class AddUserIndexToQuestions < ActiveRecord::Migration
  def change
    add_index :questions, :user_id
  end
end
