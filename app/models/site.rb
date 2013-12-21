class Site < ActiveRecord::Base
  belongs_to :communities_page, :class_name => 'Page',
    :foreign_key => :communities_page_id
  belongs_to :about_page, :class_name => 'Page',
    :foreign_key => :about_page_id
  has_one :podcast
  
  validates :title, :presence => true
  validates :email, :presence => true
  
  def email_domain
    "@#{email.split('@')[1]}"
  end

  def initials
    initials = ''
    if title
      title.split.each do |word|
        initials << word[0]
      end
    end
    initials
  end
end
