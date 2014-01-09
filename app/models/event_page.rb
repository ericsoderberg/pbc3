class EventPage < ActiveRecord::Base
  belongs_to :event
  belongs_to :page
  
  def self.share(referenceEvent, pages, update_replicas=false)
    EventPage.transaction do
      events = (update_replicas ? referenceEvent.peers : [referenceEvent])
      events.each do |event|
        # remove existing shared pages that aren't specified
        event.event_pages.each do |event_page|
          next if pages.include?(event_page.page)
          event_page.destroy!
        end
        # add new ones that we don't have yet
        pages.each do |page|
          event_page = event.event_pages.where('page_id = ?', page.id).first
          unless event_page
            event_page = EventPage.new(:event_id => event.id,
              :page_id => page.id)
          end
          event_page.save!
        end
      end
    end
  end
  
end
