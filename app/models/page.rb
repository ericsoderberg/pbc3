class Page < ActiveRecord::Base
  #before_save :render_text
  acts_as_url :prefixed_name, :sync_url => true

  has_many :page_elements, -> { order('index ASC').includes(:element) }, :autosave => true
  has_many :containing_page_elements, as: :element, :class_name => 'PageElement'

  has_many :contacts, -> { includes(:user).order('users.first_name ASC') },
    :dependent => :destroy
  has_many :contact_users, -> { order('users.first_name ASC') }, :through => :contacts, :source => :user
  has_many :authorizations, -> { includes(:user).order('users.first_name ASC') }, :dependent => :destroy
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  has_one :podcast

  validates :name, :presence => true
  validates :url, :uniqueness => true
  validate :reserved_urls

  after_create :add_initial_text

  include Searchable
  search_on :name

  # DEPRECATED
  belongs_to :style
  has_many :notes, -> { order('created_at DESC') }
  has_many :photos, :dependent => :destroy
  has_many :videos, -> { order('date DESC', 'caption ASC') }, :dependent => :destroy
  has_many :audios, -> { order('date DESC', 'caption ASC') }, :dependent => :destroy
  has_many :documents, -> { order('published_at DESC') }, :dependent => :destroy
  has_many :events, -> { order('start_at ASC') }, :dependent => :destroy
  has_many :event_pages, :dependent => :destroy
  has_many :shared_events, :through => :event_pages, :class_name => 'Event', :source => :event
  has_many :forms, -> { order('LOWER(name) ASC') }, :dependent => :destroy
  has_many :conversations, -> { order('created_at DESC') }, :dependent => :destroy
  has_one :group
  belongs_to :parent, :class_name => 'Page'
  has_many :children, -> { order(:parent_index) }, :class_name => 'Page',
    :foreign_key => :parent_id

  #LAYOUTS = ['regular', 'landing', 'gallery', 'blog', 'forum', 'event']
  #CHILD_LAYOUTS = ['header', 'feature', 'panel', 'landing']

  # order matters since we store an index to this array
  #CONTENT_TYPES = ['text', 'events and contacts', 'documents and forms',
  #  'child pages', 'photos', 'vides', 'audios', 'social']

  #validates :layout, :presence => true, :inclusion => {:in => LAYOUTS}
  #validates :child_layout, :presence => true, :inclusion => {:in => CHILD_LAYOUTS}
  #validates :home_feature, :inclusion => {:in => [true, false]}
  #validates :parent_feature, :inclusion => {:in => [true, false]}
  validates :private, :inclusion => {:in => [true, false]}
  #validates :parent_index, :uniqueness => {:scope => :parent_id,
  #  :unless => Proc.new{|p| not p.parent_id}},
  #  :numericality => {:greater_than_or_equal_to => 0,
  #    :unless => Proc.new{|p| not p.parent_id}}
  #validates :home_feature_index,
  #  :uniqueness => {:if => Proc.new {|p| p.home_feature?}}
  validate :reserved_urls

  #before_create do # DEPRECATED
  #  self.layout = 'regular'
  #  self.child_layout = 'header'
  #  self.aspect_order = 't,c,e,d,f,p,v,a,s'
  #  self.style = (self.parent ? self.parent.style : Style.first)
  #  self.private = self.parent.private if self.parent
  #  self.parent_index = self.parent ? self.parent.children.length + 1 : 1
  #  if self.parent
  #    # transfer authorizations
  #    self.parent.authorizations.each do |authorization|
  #      self.authorizations.build(:user_id => authorization.user_id,
  #        :administrator => authorization.administrator)
  #    end
  #  end
  #end

  #before_validation do # DEPRECATED
  #  unless self.style_id
  #    self.home_feature = false
  #    self.parent_feature = false
  #  end
  #  self.home_feature_index = nil if not home_feature?
  #  self.parent_feature_index = nil if not parent_feature?
  #  # map old page_types to new layouts
  #  if %w(main leaf post).include?(self.layout)
  #    self.layout = 'regular'
  #  end
  #  if not self.child_layout
  #    self.child_layout = (self.landing? ? 'landing' : 'header')
  #  end
  #end

  #before_validation(:on => :create) do # DEPRECATED
  #  if parent
  #    self.parent_index = (parent.children.map{|c| c.parent_index}.max || 0) + 1
  #  end
  #end

  def add_initial_text
    text = Text.new(text: "# #{self.name}")
    page_element = self.page_elements.create({
      page: self,
      element: text,
      index: self.page_elements.length + 1
    })
  end

  def prefixed_name
    "#{url_prefix} #{name}".strip
  end

  #def name_with_parent
  #  parent ? "#{name} -#{parent.name}-" : name
  #end

  def self.find_by_url_or_alias(url)
    result = Page.find_by(url: url)
    if not result
      Page.where('url_aliases ILIKE ?', '%' + url + '%').each do |page|
        if page.url_aliases.split.include?(url)
          result = page
          break
        end
      end
    end
    result
  end

  def reserved_urls
    if %w(styles resources accounts users site forms payments
      audit_logs email_lists holidays home hyper calendar search
      authors messages series books blogs forums podcast).include?(url)
      errors.add(:title, "url (prefix + name) is reserved")
    end
  end

  #def self.home_feature_pages(user=nil) # DEPRECATED
  #  visible(user).where(['home_feature = ?', true]).order('home_feature_index ASC')
  #end

  #def feature_children(user=nil) # DEPRECATED
  #  Page.where(:parent_id => self.id).visible(user).where(['parent_feature = ?', true]).order('parent_feature_index ASC')
  #end

  def self.visible(user)
    email_list_names = []
    if (user and not user.administrator?)
      # special case this one since we have to check with the email lists
      email_list_names = user.email_lists.map{|el| el.name}
    end
    includes(:authorizations).
    where('? OR pages.private = ? OR ' +
      '(pages.any_user = ? AND ?) OR ' +
      'authorizations.user_id = ? OR ' +
      '(pages.allow_for_email_list = ? AND pages.email_list IN (?))',
      (user ? user.administrator? : false), false, true, (user ? true : false),
      (user ? user.id : -1), true, email_list_names).references(:authorizations)
  end

  include ActionView::Helpers::SanitizeHelper

  #def render_text
  #  self.snippet_text = strip_tags(strip_links(self.text))
  #end

  def to_param
    url
  end

  def date
    updated_at
  end

  #def nav_context # DEPRECATED
  #  (self.parent and 'blog' != self.parent.layout and 'header' == self.parent.child_layout and
  #    (self.children.empty? or 'header' != self.child_layout)) ? self.parent : self
    #(not self.landing? and self.parent and self.parent.regular? and
    #self.children.empty?) ? self.parent : self
  #end

  def authorized?(user)
    return true unless self.private?
    return true if user and user.administrator?
    return true if user and self.any_user?
    authorizations.each{|a| return true if user == a.user}
    return false unless email_list and allow_for_email_list? and user
    return true if user.email_lists.map{|el| el.name}.include?(email_list)
    return false
  end

  def searchable?(user)
    # administrators can see everything
    return true if user and user.administrator?
    return true if user and self.any_user?
    # ok if user is logged in and specifcally authorized
    authorizations.each{|a| return true if user == a.user}
    # ok if authorizing by email list and user is in list
    return true if user and email_list and allow_for_email_list? and
      user.email_lists.map{|el| el.name}.include?(email_list)
    # at this point, either there isn't a user or the user isn't on the right list
    return false if self.private? or self.obscure?
    return true
  end

  def administrator?(user)
    return false unless user
    return true if user.administrator?
    authorizations.each{|a| return true if user == a.user and a.administrator?}
    return parent.administrator?(user) if parent
    return false
  end

  def access_administrator?(user)
    return false unless user
    authorizations.each{|a| return true if user == a.user and a.administrator?}
    return false
  end

  def for_user?(user)
    return false unless user
    authorizations.each{|a| return true if user == a.user}
    return false unless email_list
    return true if user.email_lists.map{|el| el.name}.include?(email_list)
    return false
  end

=begin
  #def root # DEPRECATED
  #  parent ? parent.root : self
  #end

  #def ancestors # DEPRECATED
  #  parent ? (parent.ancestors << parent) : []
  #end

  #def descendants # DEPRECATED
  #  children.map{|child| [child] + child.descendants}.flatten
  #end

  #def includes?(page) # DEPRECATED
  #  children.each do |child|
  #    return true if page == child or child.includes?(page)
  #  end
  #  return false
  #end

  #def next_sibling # DEPRECATED
  #  if parent
  #    parent.children.where('parent_index = ?', (parent_index + 1)).first
  #  end
  #end

  #def previous_sibling # DEPRECATED
  #  if parent
  #    parent.children.where('parent_index = ?', (parent_index - 1)).first
  #  end
  #end

  #def possible_parents # DEPRECATED
  #  Page.order('name').to_a.delete_if do |page|
  #    # don't allow circular references
  #    page == self or self.includes?(page)
  #  end
  #end

  #def possible_aspects(user) # DEPRECATED
  #  case layout
  #  when 'blog', 'forum'
  #    if user.administrator?
  #      %w(location text email contacts access style feature)
  #    else
  #      %w(text email contacts access style)
  #    end
  #  else
  #    if user.administrator?
  #      %w(location text photos videos audios documents forms email
  #        contacts access style feature podcast social events)
  #    else
  #      %w(text photos videos audios documents forms email
  #        contacts access style social events)
  #    end
  #  end
  #end

  #def visible_aspects(args={}) # DEPRECATED
  #  aspect_order.split(',').delete_if do |aspects|
  #    not render_aspects?(aspects, args)
  #  end
  #end

  # aspects can be a concatenated string of characters
  def render_aspects?(aspects, args={}) # DEPRECATED
    aspects.split('').each do |aspect|
      # if any match, return true
      case aspect
      when 't'
        return (text and not text.empty?)
      when 's'
        return (secondary_text and not secondary_text.empty?)
      when 'e'
        return ('event' != layout and
          args[:categorized_events] and
          not args[:categorized_events].empty? and
          not args[:categorized_events][:all].empty?)
      when 'c'
        return (not contacts.empty?)
      when 'm'
        return (email_list and not email_list.empty?)
      when 'd'
        return (not documents.empty?)
      when 'f'
        return (not forms.empty?)
      when 'p'
        return (not photos.empty?)
      when 'v'
        return (not videos.empty?)
      when 'a'
        return (not audios.empty?)
      when 'h'
        return true # always can show if asked for since that's where we edit (change?)
      when 'g'
        return ('panel' == child_layout and
          args[:children] and not args[:children].empty?)
      when 'F'
        return (facebook_url and not facebook_url.empty?)
      when 'T'
        return (twitter_name and not twitter_name.empty?)
      else
        logger.error "Unknown page aspect: #{aspect}"
        return false
      end
    end
    return false
  end
=end

  def order_elements(ids)
    result = true
    Page.transaction do
      ids.each_with_index do |id, i|
        page_element = PageElement.find(id)
        page_element.index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless page_element.save(:validate => false)
      end
    end
    result
  end

=begin
  def self.order_children(ids) # DEPRECATED
    result = true
    Page.transaction do
      tmp_children = Page.find(ids)
      ids.each_with_index do |id, i|
        child = tmp_children.detect{|c| id == c.id}
        child.parent_index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless child.save(:validate => false)
      end
    end
    result
  end
=end

  def self.editable(user)
    Page.order('name ASC').to_a.select{|p| p.administrator?(user) }
  end

=begin
  def self.order_home_features(ids) # DEPRECATED
    result = true
    Page.transaction do
      tmp_features = Page.find(ids)
      ids.each_with_index do |id, i|
        feature_page = tmp_features.detect{|c| id == c.id}
        feature_page.home_feature_index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless feature_page.save(:validate => false)
      end
    end
    result
  end

  def self.order_parent_features(ids) # DEPRECATED
    result = true
    Page.transaction do
      tmp_features = Page.find(ids)
      ids.each_with_index do |id, i|
        feature_page = tmp_features.detect{|c| id == c.id}
        feature_page.parent_feature_index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless feature_page.save(:validate => false)
      end
    end
    result
  end
=end

  def normalize_indexes
    PageElement.transaction do
      page_elements.each_with_index do |page_element, i|
        if (i+1) != page_element.index
          page_element.index = i+1
          page_element.save
        end
      end
    end
  end

=begin
  def related_events(start_date=Date.today.beginning_of_day,
      stop_date=Date.today.beginning_of_day + 6.months)
    page_ids = [self.id] + self.descendants.map{|page| page.id}
    result =
      Event.between(start_date, stop_date).includes(:event_pages).
      where('events.page_id IN (?) OR event_pages.page_id IN (?)', page_ids, page_ids).
      references(:event_pages).
      order("start_at ASC, (events.page_id <> #{self.id})").to_a
    result
  end

  def categorized_related_events(start_date=Date.today.beginning_of_day,
      stop_date=Date.today.beginning_of_day + 6.months)
      Event.categorize(related_events(start_date, stop_date))
  end

  def categorized_events
    Event.categorize(events)
  end

  def landing? # DEPRECATED
    'landing' == layout
  end

  def regular? # DEPRECATED
    'regular' == layout
  end

  def blog? # DEPRECATED
    'blog' == layout
  end

  def forum? # DEPRECATED
    'forum' == layout
  end

  def gallery? # DEPRECATED
    'gallery' == layout
  end

  def event? # DEPRECATED
    'event' == layout
  end

  def feed_page # DEPRECATED
    if self.podcast or 'blog' == self.layout
      self
    elsif self.parent and 'blog' == self.parent.layout
      self.parent
    else
      nil
    end
  end

  def color # DEPRECATED
    self.style ? self.style.feature_color.to_s(16) : '#ccc'
  end
=end

  def possible_linked_pages
    pages = Page.where('id != ?', self.id)
    linkedPageIds = self.page_elements.where('element_type = ?', "Page").map{|pe| pe.element_id}
    if linkedPageIds.count > 0
      pages = pages.where('id NOT IN (?)', linkedPageIds)
    end
    return pages.order('LOWER(name) ASC')
  end

  def convert_to_page_elements
    if page_elements.empty?
      # use PageElement
      index = 1
      aspect_order.split(',').each do |aspect|
        case aspect
        when 't'
          newText = Text.new(text: self.text)
          page_elements.build(element: newText, page: self, index: index)
          index += 1
        when 's'
          newText = Text.new(text: self.secondary_text)
          page_elements.build(element: newText, page: self, index: index)
          index += 1
        when 'e'
          events.each do |event|
            page_elements.build(element: event, page: self, index: index)
            index += 1
          end
        when 'c'
          contacts.each do |contact|
            page_elements.build(element: contact, page: self, index: index)
            index += 1
          end
        when 'd'
          documents.each do |document|
            page_elements.build(element: document, page: self, index: index)
            index += 1
          end
        when 'f'
          forms.each do |form|
            page_elements.build(element: form, page: self, index: index)
            index += 1
          end
        when 'p'
          photos.each do |photo|
            page_elements.build(element: photo, page: self, index: index)
            index += 1
          end
        when 'v'
          videos.each do |video|
            page_elements.build(element: video, page: self, index: index)
            index += 1
          end
        when 'a'
          audios.each do |audio|
            page_elements.build(element: audio, page: self, index: index)
            index += 1
          end
        when 'g'
          children.each do |child|
            page_elements.build(element: child, page: self, index: index)
            index += 1
          end
        end
      end
    end
  end

  def self.matches(text)
    result = nil

    if text and not text.empty?
      score = 0

      # try full title first
      clause = 'pages.name ilike :pn'
      args = {:pn => "#{text}"}
      pages = Page.where(clause, args)
      if pages.length == 1
        score += 1
      else
        clause = 'pages.name ~* :en'
        args = {:en => text.strip.split(' ').join('|')}
        events = Page.where(clause, args)
      end

      if not pages.empty?
        result = {type: 'page', text: text, matches: pages, score: score,
          clause: clause, args: args}
      end
    end

    result
  end

  private

  def extract_first_paragraph(str) # DEPRECATED
    return '' unless str
    matches = str.scan(/<p>(.*)<\/p>/)
    # TODO: improve this to not include styling from text editor
    return (matches and matches[0] ? matches[0][0] : '')
  end

end
