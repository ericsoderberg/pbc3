class Newsletter < ActiveRecord::Base
  belongs_to :featured_page, :class_name => 'Page'
  belongs_to :featured_event, :class_name => 'Event'
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  validates :name, :presence => true
  validates :published_at, :presence => true, :uniqueness => {:scope => :name}
  
  def to_param
    published_at.strftime("%Y-%m-%d")
  end
  
  def full_name
    name + ' - ' + published_at.relative_str(true)
  end
  
  def events
    Event.featured.between(published_at, published_at + window.weeks).
      order('start_at ASC').select{|e|
        e.authorized?(nil) and not e.page.obscure? and
        (! e.prev || e.prev.start_at < published_at) and
        e.messages.empty?
      }
  end
  
  def next_message
    Message.between(published_at, published_at + 1.week).first;
  end
  
  def previous_message
    Message.between(published_at - 2.weeks, published_at).last;
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
