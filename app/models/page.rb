class Page < ActiveRecord::Base
  before_save :render_text
  acts_as_url :name
  
  has_attached_file :text_image, :styles => {
      :normal => '120x',
      :thumb => '50x'
    }
  has_attached_file :feature_image, :styles => {
      :normal => '200x',
      :thumb => '50x'
    }
  has_attached_file :hero_background, :styles => {
      :normal => '980x445',
      :thumb => '50x'
    }
  
  belongs_to :page_banner
  has_many :notes, :order => 'created_at DESC'
  has_many :photos
  has_many :videos
  has_many :events, :order => 'start_at ASC'
  has_one :group
  belongs_to :parent, :class_name => 'Page'
  has_many :children, :class_name => 'Page', :foreign_key => :parent_id
  has_many :contacts
  has_many :contact_users, :through => :contacts, :source => :user
  
  validates_presence_of :name

  def render_text
    self.rendered_text = BlueCloth.new(self.text).to_html
    self.rendered_feature_text = BlueCloth.new(self.feature_text).to_html
  end
  
  def to_param
    url
  end
  
end
