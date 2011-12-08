class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name, :name, :administrator,
    :avatar_file_name, :avatar_content_type, :avatar_file_size,
    :avatar_updated_at, :avatar,
    :portrait_file_name, :portrait_content_type, :portrait_file_size,
    :portrait_updated_at, :portrait,
    :bio, :email_confirmation
  
  has_many :contacts, :dependent => :destroy
  has_many :contact_pages, :through => :contacts, :source => :page,
    :order => 'LOWER(pages.name) ASC'
  has_many :authorizations, :dependent => :destroy
  has_many :filled_forms, :dependent => :destroy
  has_many :payments, :dependent => :destroy
  has_many :conversations, :dependent => :destroy
  has_many :users_videos, :dependent => :destroy, :class_name => 'UsersVideos'
  has_many :videos, :through => :users_videos, :source => :video
  acts_as_audited :except => [:password, :password_confirmation]
  
  has_attached_file :avatar, :styles => {
      :normal => '50x',
    }
  has_attached_file :portrait, :styles => {
      :normal => '400x',
      :thumb => '50x'
    }
  
  before_validation do
    if self.name
      self.name = self.name.strip
      self.first_name, self.last_name = self.name.split(' ', 2)
    end
  end
  
  searchable do
    text :name, :default_boost => 2
    text :email, :default_boost => 2
  end
  
  def email_confirmation
    email
  end
  
  def authorized?(user)
    user and (user.administrator? or user == self)
  end
  
  def email_lists
    EmailList.find_by_address(email)
  end
  
end
