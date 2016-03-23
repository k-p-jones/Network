class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
         
  has_many :thoughts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :friendships
  has_many :friends, :through => :friendships
  has_many :inverse_friendships, :class_name => "Friendship", :foreign_key => "friend_id"
  has_many :inverse_friends, :through => :inverse_friendships, :source => :user
  
  def pending_requests
      self.friendships.where(:accepted => false)
  end
  
  def recieved_requests
      self.inverse_friendships.where(:accepted => false)
  end
 
  def confirmed_friends
      @friends = []
      @friends << self.friendships.where(:accepted => true) 
      @friends << self.inverse_friendships.where(:accepted => true)
      @my_friends = @friends.flatten
  end
  
  def confirmed_friends_ids
      @friends = []
      @friends << self.friendships.where(:accepted => true).pluck(:friend_id) 
      @friends << self.inverse_friendships.where(:accepted => true).pluck(:user_id)
      @my_friends = @friends.flatten
  end
  
  def my_friends
    @active = self.friendships.pluck(:friend_id)
    @passive = self.inverse_friendships.pluck(:user_id)
    @the_ids = []
    @the_ids << @active
    @the_ids << @passive
    @my_friends = @the_ids.flatten
  end
end