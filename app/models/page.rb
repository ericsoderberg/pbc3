class Page < ActiveRecord::Base
  before_save :render_text
  acts_as_url :prefixed_name, :sync_url => true
  
  belongs_to :style
  has_many :notes, :order => 'created_at DESC'
  has_many :photos
  has_many :videos
  has_many :audios
  has_many :documents
  has_many :events, :order => 'start_at ASC'
  has_one :group
  belongs_to :parent, :class_name => 'Page'
  has_many :children, :class_name => 'Page', :foreign_key => :parent_id,
    :order => :parent_index
  has_many :contacts
  has_many :contact_users, :through => :contacts, :source => :user
  has_many :authorizations
  has_one :podcast
  has_many :forms
  acts_as_audited :except => [:parent_index, :feature_index]
  
  LAYOUTS = ['regular', 'landing', 'gallery', 'blog', 'forum']

  validates :layout, :presence => true, :inclusion => {:in => LAYOUTS}
  validates :name, :presence => true
  validates :featured, :inclusion => {:in => [true, false]}
  validates :private, :inclusion => {:in => [true, false]}
  validates :url, :uniqueness => true
  validates :parent_index, :uniqueness => {:scope => :parent_id,
    :unless => Proc.new{|p| not p.parent_id}}
  validates :feature_index,
    :uniqueness => {:if => Proc.new {|p| p.featured?}}
  validate :reserved_urls
  
  before_validation do
    self.feature_index = nil if not featured?
    # map old page_types to new layouts
    if %w(main leaf post).include?(self.layout)
      self.layout = 'regular'
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
  
  def self.find_by_url_or_alias(url)
    result = Page.find_by_url(url)
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
      authors messages series books).include?(url)
      errors.add(:name, "that url prefix + name is reserved")
    end
  end
  
  def self.featured_pages(user=nil)
    visible(user).where(['featured = ?', true]).order('feature_index ASC')
  end
  
  def self.visible(user)
    includes(:authorizations).
    where('? OR pages.private = ? OR authorizations.user_id = ?',
      (user ? user.administrator? : false), false,
      (user ? user.id : -1))
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
  
  def nav_context
    (self.parent and self.parent.regular? and
    self.children.empty?) ? self.parent : self
  end
  
  def authorized?(user)
    return true unless self.private?
    return true if user and user.administrator?
    authorizations.each{|a| return true if user == a.user}
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
  
  def possible_parents
    Page.order('name').all.delete_if do |page|
      # don't allow circular references
      page == self or self.includes?(page)
    end
  end
  
  def possible_aspects
    case layout
    when 'landing', 'blog', 'forum'
      %w(text contacts access feature)
    else
      %w(text photos videos audios documents forms
        contacts access feature podcast events)
    end
  end
  
  def order_children(ids)
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
  
  def self.order_features(ids)
    result = true
    Page.transaction do
      tmp_features = Page.find(ids)
      ids.each_with_index do |id, i|
        feature_page = tmp_features.detect{|c| id == c.id}
        feature_page.feature_index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless feature_page.save(:validate => false)
      end
    end
    result
  end
  
  def self.normalize_indexes(pages=nil)
    pages = Page.all unless pages
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
      Event.between(start_date, stop_date).
      where(:page_id => page_ids).
      order("start_at ASC").all
    result
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
  
  private
  
  def extract_first_paragraph(str)
    return '' unless str
    matches = str.scan(/<p>(.*)<\/p>/)
    # TODO: improve this to not include styling from yui editor
    return (matches and matches[0] ? matches[0][0] : '')
  end
  
end
