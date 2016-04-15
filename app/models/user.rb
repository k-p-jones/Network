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
  has_many :likes
  has_attached_file :avatar, styles: { medium: "300x300>", thumb: "40x40#", network: "200x200#" }, default_url: "http://placehold.it/300x300"
  validates_attachment_content_type :avatar, content_type: /\Aimage\/.*\Z/
  
  def pending_requests
      self.friendships.where(:accepted => false)
  end

  def pending_requests_ids
      @array = self.pending_requests.pluck(:friend_id)
      @ids = []
      @ids << @array
      @pending_requests_ids = @ids.flatten
  end
  
  def recieved_requests
      self.inverse_friendships.where(:accepted => false)
  end

  def recieved_requests_ids
      @array = self.recieved_requests.pluck(:user_id)
      @ids = []
      @ids << @array
      @pending_requests_ids = @ids.flatten
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

  def confirmed_profile_friendship(user_id, current_user)
    self.confirmed_friends.select do |x|
      if x["friend_id"] == user_id && x["user_id"] == current_user.id
        @friendship = x
      elsif x["user_id"] == user_id && x["friend_id"] == current_user.id
        @friendship = x
      end
    end
    return @friendship
  end
  
  def my_friends
    @active = self.friendships.pluck(:friend_id)
    @passive = self.inverse_friendships.pluck(:user_id)
    @the_ids = []
    @the_ids << @active
    @the_ids << @passive
    @my_friends = @the_ids.flatten
  end

  # Like methods
  def has_liked(thought_id)
    @likes = self.likes.pluck(:thought_id)
    if @likes.include?(thought_id)
      return true
    end
  end
end