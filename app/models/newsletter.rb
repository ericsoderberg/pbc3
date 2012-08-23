class Newsletter < ActiveRecord::Base
  belongs_to :featured_page, :class_name => 'Page'
  belongs_to :featured_event, :class_name => 'Event'
  
  validates :name, :presence => true
  validates :published_at, :presence => true, :uniqueness => {:scope => :name}
  
  def to_param
    published_at.strftime("%Y-%m-%d")
  end
  
  def full_name
    name + ' - ' + published_at.relative_str(true)
  end
  
  def events
    Event.featured.between(published_at, published_at + 1.month).order('start_at ASC').select{|e| e.authorized?(nil) and not e.page.obscure?}
  end
  
  def next_message
    Message.between(published_at, published_at + 1.week).first;
  end
  
  def previous_message
    Message.between(published_at - 2.week, published_at).last;
  end
  
  def previous
    Newsletter.where('published_at < ?', [published_at]).
      order('published_at DESC').first
  end
  
  def next
    Newsletter.where('published_at > ?', [published_at]).
      order('published_at ASC').first
  end
  
end
