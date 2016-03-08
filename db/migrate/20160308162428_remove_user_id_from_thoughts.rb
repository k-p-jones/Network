class RemoveUserIdFromThoughts < ActiveRecord::Migration
  def change
    remove_column :thoughts, :user_id
  end
end
