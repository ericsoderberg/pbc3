class Site < ActiveRecord::Base
  belongs_to :communities_page, :class_name => 'Page',
    :foreign_key => :communities_page_id
  belongs_to :about_page, :class_name => 'Page',
    :foreign_key => :about_page_id
  has_one :podcast
  ###audited
  
  ###attr_protected :id
  
  validates :title, :presence => true
  validates :email, :presence => true
  
  def email_domain
    "@#{email.split('@')[1]}"
  end
end
