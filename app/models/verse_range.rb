class VerseRange < ActiveRecord::Base
  belongs_to :message
  
  ###attr_protected :id
end
