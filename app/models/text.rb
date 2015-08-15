class Text < ActiveRecord::Base
  has_many :page_elements, as: :element, :dependent => :destroy
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'

  def self.matches(text)
    tokens = nil
    terms = text.strip.split(' ')
    index = 0
    clause = 'texts.text ilike :text'

    while index < terms.length
      term = terms[index]
      args = {:text => "%#{term}%"}
      texts = Text.where(clause, args)
      score = 0
      if texts.length == 1 and texts.first.text == term
        score += 1
      end

      if not texts.empty?
        tokens = {type: 'text', text: term, matches: texts, score: score,
          clause: clause, args: args}
      end

      index += 1
    end

    tokens
  end
end
