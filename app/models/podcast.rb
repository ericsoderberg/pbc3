class Podcast < ActiveRecord::Base
  belongs_to :page
  belongs_to :site
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_attached_file :image, :styles => {
      :normal => '600x600',
      :thumb => '50x50'
    }
  acts_as_audited
    
  validates_presence_of :user_id, :title, :subtitle,
    :summary, :description, :category
  validates :page_id, :uniqueness => true, :allow_nil => true
  validates :site_id, :uniqueness => true, :allow_nil => true
  
  def pages
    page ?
      page.children.order("updated_at DESC").limit(20) :
      []
  end
  
  def messages
    site ?
      Message.includes(:message_files).where("message_files.file_content_type ILIKE 'audio%'").order("date DESC").limit(20) :
      []
  end
  
end
