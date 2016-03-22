class Friendship < ActiveRecord::Base
   
    belongs_to :user
    belongs_to :friend, :class_name => "User"
    validates :user_id, presence: true
    validates :friend_id, presence: true
    validates_uniqueness_of :user_id, :scope => :friend_id
    validate :disallow_self_referential_friendship

    def disallow_self_referential_friendship
      if friend_id == user_id
        errors.add(:friend_id, 'cannot add yourself')
      end
    end
end
