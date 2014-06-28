class Site < ActiveRecord::Base
  belongs_to :communities_page, class_name: 'Page', foreign_key: :communities_page_id
  belongs_to :about_page, class_name: 'Page', foreign_key: :about_page_id
  has_one :podcast
  
  has_attached_file :icon, :styles => {
      :normal => '64x',
      :thumb => '48x'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
    
  has_attached_file :wordmark, :styles => {
      :normal => 'x64',
      :thumb => 'x48'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  
  validates :title, :presence => true
  validates :email, :presence => true
  
  def email_domain
    "@#{email.split('@')[1]}"
  end
  
  def primary_pages
    Page.where('site_primary = ?', true).order(:parent_index)
  end
  
end
