class AddUserToThoughts < ActiveRecord::Migration
  def change
    add_reference :thoughts, :user, index: true, foreign_key: true
  end
end
