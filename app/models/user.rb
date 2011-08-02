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
    :bio
  
  has_many :contacts
  has_many :contact_pages, :through => :contacts, :source => :page,
    :order => 'LOWER(pages.name) ASC'
  has_many :authorizations
  has_many :filled_forms
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
  
end
