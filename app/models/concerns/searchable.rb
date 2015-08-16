module Searchable
  extend ActiveSupport::Concern

  module ClassMethods

    attr_reader :search_attributes

    def search_tokens(text)
      tokens = nil
      terms = text.strip.split(' ')
      index = 0

      clause = self.search_attributes.map do |attribute|
        "#{table_name}.#{attribute} ILIKE :term"
      end.join(' OR ')

      while index < terms.length
        term = terms[index]
        args = {:term => "%#{term}%"}
        items = self.where(clause, args)
        score = 0
        if items.length == 1 and self.search_attributes.select{|a| items.first[a] == term}.length > 0
          score += 1
        else
          clause = self.search_attributes.map do |attribute|
            "#{table_name}.#{attribute} ~* :term"
          end.join(' OR ')
          args = {:term => text.strip.split(' ').join('|')}
          items = self.where(clause, args)
        end

        if not items.empty?
          tokens = {type: self.class.name, text: term, matches: items, score: score,
            clause: clause, args: args}
        end

        index += 1
      end

      tokens
    end

    def search(text)
      tokens = search_tokens(text)
      tokens ? self.where(tokens[:clause], tokens[:args]) : none
    end

    private

    def search_on(attribute)
      @search_attributes = attribute.respond_to?('map') ? attribute : [attribute]
    end
  end
end
