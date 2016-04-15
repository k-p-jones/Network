class Like < ActiveRecord::Base
  belongs_to :user
  belongs_to :thought
  validates_uniqueness_of :user_id, :scope => :thought_id
  validates :user_id, presence: true
end
