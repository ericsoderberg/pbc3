class Podcast < ActiveRecord::Base
  belongs_to :page
  belongs_to :owner, :class_name => 'User', :foreign_key => 'user_id'
  has_attached_file :image, :styles => {
      :normal => '600x600',
      :thumb => '50x50'
    }
  acts_as_audited
    
  validates_presence_of :page, :user_id, :title, :subtitle,
    :summary, :description, :category
  
  def pages
    page.children.order("updated_at DESC").limit(20) 
  end
end
