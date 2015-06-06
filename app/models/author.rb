class Author < ActiveRecord::Base
  has_many :message_sets
  has_many :messages, -> {order('date desc')}
  acts_as_url :name, :sync_url => true
  
  validates :name, :presence => true
  
  searchable do
    text :name, :default_boost => 2
  end
  
  def authorized?(user)
    true
  end
  
  def searchable?(user)
    true
  end
  
  def to_param
    url
  end
  
  def first_year
    messages.empty? ? Date.today.year : messages.last.date.year
  end
  
  def last_year
    messages.empty? ? Date.today.year : messages.first.date.year
  end
  
  def yearly_density
    messages.count.to_f / ([1, (last_year - first_year)].max)
  end
  
  def self.matches(text)
    result = nil
    terms = text.strip.split(' ')
    index = 0
    clause = 'authors.name ilike :an'
    
    while index < terms.length
      term = terms[index]
      next_term = terms[index+1]
      score = 0
      authors = Author.none
      
      # try full name first
      if next_term
        args = {:an => "#{term} #{next_term}"}
        authors = Author.where(clause, args)
        if not authors.empty?
          term += ' ' + next_term
          index += 1
          score += 1 if authors.length == 1
        end
      end
      
      if authors.empty?
        args = {:an => "%#{term}%"}
        authors = Author.where(clause, args)
      end
      
      if not authors.empty?
        result = {type: 'author', text: term, matches: authors, score: score,
          clause: clause, args: args}
      end
      
      index += 1
    end
    
    result
  end
  
end
