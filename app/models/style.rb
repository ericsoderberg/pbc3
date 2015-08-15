class Style < ActiveRecord::Base
  has_attached_file :banner, :styles => {
    :normal => '980x245',
    :thumb => '50x'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :feature_strip, :styles => {
      :normal => '200x200',
      :thumb => '50x'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :hero, :styles => {
      :normal => '980x445',
      :thumb => '50x25'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :bio_back, :styles => {
      :normal => '201x308',
      :thumb => '50x'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  has_attached_file :child_feature, :styles => {
      :normal => '313x',
      :thumb => '50x'
    },
    :path => ":rails_root/public/system/:attachment/:id/:style/:filename",
    :url => "/system/:attachment/:id/:style/:filename"
  has_many :pages, :dependent => :nullify
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'

  validates_presence_of :name, :hero_text_color, :feature_color

  def authorized?(user)
    user and user.administrator?
  end

  def searchable?(user)
    user and user.administrator?
  end

  before_save :update_css

  def update_css
    if feature_color
      self.css = "background-color: ##{feature_color.to_s(16)};"
    end
  end
end
