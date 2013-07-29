class Podcast < ActiveRecord::Base
  belongs_to :page
  belongs_to :site
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_attached_file :image, :styles => {
      :normal => '600x600',
      :thumb => '50x50'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  ###audited
  
  ###attr_protected :id
    
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
  
  def items
    if page
      result = []
      result.concat(page.children.order("updated_at DESC").limit(20).all)
      result.concat(page.audios.where("date is not null").order("date DESC").limit(20).all)
      result.concat(page.videos.where("date is not null").order("date DESC").limit(20).all)
      # order by date
      result.sort{|i1, i2| i2.date <=> i1.date}
    elsif site
      Message.includes(:message_files).
        where("message_files.file_content_type ILIKE 'audio%'").
        order("date DESC").limit(20).references(:message_files)
    end
  end
  
end
