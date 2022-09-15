class CreateFollowedLists < ActiveRecord::Migration[6.1]
  def change
    create_join_table :users, :lists
  end
end
