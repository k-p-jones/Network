class Comment < ActiveRecord::Base
  belongs_to :thought
  belongs_to :user
  
  validates :content, presence: true
end
