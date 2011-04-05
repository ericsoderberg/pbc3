class PageBanner < ActiveRecord::Base
  has_attached_file :image, :styles => {
    :normal => '980x245',
    :thumb => '50x'
    }
  has_many :pages
  
  validates_presence_of :image_file_name
end
