class Page < ActiveRecord::Base
  before_save :render_text
  acts_as_url :name
  has_attached_file :text_image, :styles => {
      :normal => '200x',
      :thumb => '50x'
    }
  has_attached_file :feature_image, :styles => {
      :normal => '200x',
      :thumb => '50x'
    }
  
  has_many :notes, :order => 'created_at DESC'
  has_many :photos
  has_many :videos
  has_one :group

  def render_text
    self.rendered_text = BlueCloth.new(self.text).to_html
    self.rendered_feature_text = BlueCloth.new(self.feature_text).to_html
  end
  
  def to_param
    url
  end
  
end
