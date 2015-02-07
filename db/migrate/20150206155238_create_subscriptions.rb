class CreateSubscriptions < ActiveRecord::Migration
  def change
    create_table :subscriptions do |t|
      t.references :question, index: true
      t.references :user, index: true

      t.timestamps
    end
  end
end
