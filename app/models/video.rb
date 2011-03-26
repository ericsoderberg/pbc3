class Video < ActiveRecord::Base
  belongs_to :page
  has_attached_file :video
end
