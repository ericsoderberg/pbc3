class Page < ActiveRecord::Base
  before_save :render_text
  acts_as_url :prefixed_name, :sync_url => true
  
  belongs_to :style
  has_many :notes, -> { order('created_at DESC') }
  has_many :photos, :dependent => :destroy
  has_many :videos, -> { order('date DESC', 'caption ASC') }, :dependent => :destroy
  has_many :audios, -> { order('date DESC', 'caption ASC') }, :dependent => :destroy
  has_many :documents, -> { order('published_at DESC') }, :dependent => :destroy
  has_many :events, -> { order('start_at ASC') }, :dependent => :destroy
  has_many :event_pages, :dependent => :destroy
  has_many :shared_events, :through => :event_pages, :class_name => 'Event', :source => :event
  has_one :group
  belongs_to :parent, :class_name => 'Page'
  has_many :children, -> { order(:parent_index) }, :class_name => 'Page',
    :foreign_key => :parent_id
  has_many :contacts, -> { includes(:user).order('users.first_name ASC') },
    :dependent => :destroy
  has_many :contact_users, -> { order('users.first_name ASC') }, :through => :contacts, :source => :user
  has_many :authorizations, -> { includes(:user).order('users.first_name ASC') }, :dependent => :destroy
  has_one :podcast
  has_many :forms, -> { order('LOWER(name) ASC') }, :dependent => :destroy
  has_many :conversations, -> { order('created_at DESC') }, :dependent => :destroy
  belongs_to :updated_by, :class_name => 'User', :foreign_key => 'updated_by'
  
  LAYOUTS = ['regular', 'landing', 'gallery', 'blog', 'forum', 'event']
  CHILD_LAYOUTS = ['header', 'feature', 'panel', 'landing']
  
  # order matters since we store an index to this array
  CONTENT_TYPES = ['text', 'events and contacts', 'documents and forms',
    'child pages', 'photos', 'vides', 'audios', 'social']

  validates :layout, :presence => true, :inclusion => {:in => LAYOUTS}
  validates :child_layout, :presence => true, :inclusion => {:in => CHILD_LAYOUTS}
  validates :name, :presence => true
  validates :home_feature, :inclusion => {:in => [true, false]}
  validates :parent_feature, :inclusion => {:in => [true, false]}
  validates :private, :inclusion => {:in => [true, false]}
  validates :url, :uniqueness => true
  validates :parent_index, :uniqueness => {:scope => :parent_id,
    :unless => Proc.new{|p| not p.parent_id}},
    :numericality => {:greater_than_or_equal_to => 0,
      :unless => Proc.new{|p| not p.parent_id}}
  validates :home_feature_index,
    :uniqueness => {:if => Proc.new {|p| p.home_feature?}}
  validate :reserved_urls
  
  before_create do
    self.layout = 'regular'
    self.child_layout = 'header'
    self.aspect_order = 't,c,e,d,f,p,v,a,s'
    self.style = (self.parent ? self.parent.style : Style.first)
    self.private = self.parent.private if self.parent
    self.parent_index = self.parent ? self.parent.children.length + 1 : 1
    if self.parent
      # transfer authorizations
      self.parent.authorizations.each do |authorization|
        self.authorizations.build(:user_id => authorization.user_id,
          :administrator => authorization.administrator)
      end
    end
  end
  
  before_validation do
    unless self.style_id
      self.home_feature = false
      self.parent_feature = false
    end
    self.home_feature_index = nil if not home_feature?
    self.parent_feature_index = nil if not parent_feature?
    # map old page_types to new layouts
    if %w(main leaf post).include?(self.layout)
      self.layout = 'regular'
    end
    if not self.child_layout
      self.child_layout = (self.landing? ? 'landing' : 'header')
    end
  end
  
  before_validation(:on => :create) do
    if parent
      self.parent_index = (parent.children.map{|c| c.parent_index}.max || 0) + 1
    end
  end
  
  def prefixed_name
    "#{url_prefix} #{name}".strip
  end
  
  def name_with_parent
    parent ? "#{name} -#{parent.name}-" : name
  end
  
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
      errors.add(:name, "that url prefix + name is reserved")
    end
  end
  
  def self.home_feature_pages(user=nil)
    visible(user).where(['home_feature = ?', true]).order('home_feature_index ASC')
  end
  
  def feature_children(user=nil)
    Page.where(:parent_id => self.id).visible(user).where(['parent_feature = ?', true]).order('parent_feature_index ASC')
  end
  
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
  
  searchable do
    text :name, :default_boost => 3
    text :url_aliases, :default_boost => 2
    text :text
  end
  
  include ActionView::Helpers::SanitizeHelper

  def render_text
    self.snippet_text = strip_tags(strip_links(self.text))
  end
  
  def to_param
    url
  end
  
  def date
    updated_at
  end
  
  def nav_context
    (self.parent and 'blog' != self.parent.layout and 'header' == self.parent.child_layout and
      (self.children.empty? or 'header' != self.child_layout)) ? self.parent : self
    #(not self.landing? and self.parent and self.parent.regular? and
    #self.children.empty?) ? self.parent : self
  end
  
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
  
  def root
    parent ? parent.root : self
  end
  
  def ancestors
    parent ? (parent.ancestors << parent) : []
  end
  
  def descendants
    children.map{|child| [child] + child.descendants}.flatten
  end
  
  def includes?(page)
    children.each do |child|
      return true if page == child or child.includes?(page)
    end
    return false
  end
  
  def next_sibling
    if parent
      parent.children.where('parent_index = ?', (parent_index + 1)).first
    end
  end
  
  def previous_sibling
    if parent
      parent.children.where('parent_index = ?', (parent_index - 1)).first
    end
  end
  
  def possible_parents
    Page.order('name').to_a.delete_if do |page|
      # don't allow circular references
      page == self or self.includes?(page)
    end
  end
  
  def possible_aspects(user)
    case layout
    when 'blog', 'forum'
      if user.administrator?
        %w(location text email contacts access style feature)
      else
        %w(text email contacts access style)
      end
    else
      if user.administrator?
        %w(location text photos videos audios documents forms email
          contacts access style feature podcast social events)
      else
        %w(text photos videos audios documents forms email
          contacts access style social events)
      end
    end
  end
  
  def visible_aspects(args={})
    aspect_order.split(',').delete_if do |aspects|
      not render_aspects?(aspects, args)
    end
  end
  
  # aspects can be a concatenated string of characters
  def render_aspects?(aspects, args={})
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
  
  def self.order_children(ids)
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
  
  def self.editable(user)
    Page.order('name ASC').to_a.select{|p| p.administrator?(user) }
  end
  
  def self.order_home_features(ids)
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
  
  def self.order_parent_features(ids)
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
  
  def self.normalize_indexes(pages=nil)
    pages = Page.to_a unless pages
    Page.transaction do
      pages.each do |page|
        page.children.each_with_index do |child, i|
          if (i+1) != child.parent_index
            child.parent_index = i+1
            child.save
          end
        end
      end
    end
  end
  
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
  
  def landing?
    'landing' == layout
  end
  
  def regular?
    'regular' == layout
  end
  
  def blog?
    'blog' == layout
  end
  
  def forum?
    'forum' == layout
  end
  
  def gallery?
    'gallery' == layout
  end
  
  def event?
    'event' == layout
  end
  
  def feed_page
    if self.podcast or 'blog' == self.layout
      self
    elsif self.parent and 'blog' == self.parent.layout
      self.parent
    else
      nil
    end
  end
  
  def color
    self.style ? self.style.feature_color.to_s(16) : '#ccc'
  end
  
  private
  
  def extract_first_paragraph(str)
    return '' unless str
    matches = str.scan(/<p>(.*)<\/p>/)
    # TODO: improve this to not include styling from text editor
    return (matches and matches[0] ? matches[0][0] : '')
  end
  
end
