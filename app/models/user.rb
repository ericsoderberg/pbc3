class User < ActiveRecord::Base
  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable, :lockable and :timeoutable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me,
    :first_name, :last_name, :administrator,
    :avatar_file_name, :avatar_content_type, :avatar_file_size,
    :avatar_updated_at, :avatar
  
  has_many :contacts
  has_many :contact_pages, :through => :contacts, :source => :page
  has_many :authorizations
  has_many :filled_forms
  acts_as_audited :except => [:password, :password_confirmation]
  
  has_attached_file :avatar, :styles => {
      :normal => '50x',
    }
  
  def name
    return '' unless first_name and last_name
    first_name + ' ' + last_name
  end
  
end
