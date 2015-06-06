class Resource < ActiveRecord::Base
  has_many :reservations, :dependent => :destroy
  has_many :events, :through => :reservations
  
  TYPES = %w(room equipment)
  
  validates_presence_of :name
  validates :resource_type, :presence => true, :inclusion => {:in => TYPES}
  
  scope :rooms, -> { where(:resource_type => 'room') }
  scope :equipment, -> { where(:resource_type => 'equipment') }
  
  def other_events_during(event)
    reservations.includes(:event).between(event.start_at, event.stop_at).
      where('event_id != ?', event.id).references(:event).
      map{|reservation| reservation.event}
  end
  
  def self.matches(text)
    result = nil
    terms = text.strip.split(' ')
    index = 0
    clause = 'resources.name ilike :name'
    
    while index < terms.length
      term = terms[index]
      args = {:name => "%#{term}%"}
      resources = Resource.where(clause, args)
      score = 0
      if resources.length == 1 and resources.first.name == term
        score += 1 
      end
      
      if not resources.empty?
        result = {type: 'resource', text: term, matches: resources, score: score,
          clause: clause, args: args}
      end
      
      index += 1
    end
    
    result
  end
  
end
