class AddResolvedToQuestions < ActiveRecord::Migration
  def change
    add_column :questions, :resolved, :boolean, default: :false
  end
end
