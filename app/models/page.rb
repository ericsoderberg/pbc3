class Page < ActiveRecord::Base
  before_save :render_text
  acts_as_url :name
  
  belongs_to :style
  has_many :notes, :order => 'created_at DESC'
  has_many :photos
  has_many :videos
  has_many :documents
  has_many :events, :order => 'start_at ASC'
  has_one :group
  belongs_to :parent, :class_name => 'Page'
  has_many :children, :class_name => 'Page', :foreign_key => :parent_id,
    :order => :index
  has_many :contacts
  has_many :contact_users, :through => :contacts, :source => :user
  has_many :authorizations
  has_one :podcast
  has_many :forms
  acts_as_audited :except => [:index, :feature_index]
  
  TYPES = ['main', 'leaf', 'landing', 'blog', 'post']

  validates :page_type, :inclusion => {:in => TYPES}
  validates :name, :presence => true, :uniqueness => true
  validates :featured, :inclusion => {:in => [true, false]}
  validates :private, :inclusion => {:in => [true, false]}
  validates :url, :uniqueness => true
  validates :index, :uniqueness => {:scope => :parent_id,
    :unless => Proc.new{|p| not p.parent_id}}
  validates :feature_index,
    :uniqueness => {:if => Proc.new {|p| p.featured?}}
  validate :page_type_for_parent
  
  before_validation do
    self.feature_index = nil if not featured?
  end
  
  before_validation(:on => :create) do
    if parent
      self.index = (parent.children.map{|c| c.index}.max || 0) + 1
    end
  end
  
  def page_type_for_parent
    return unless parent
    if parent.leaf?
      errors.add(:parent_id, "leaf pages can't contain pages")
    elsif parent.post?
      errors.add(:parent_id, "post pages can't contain pages")
    elsif parent.blog? and not post?
      errors.add(:parent_id, "blog pages can only contain post pages")
    elsif parent.main? and not (leaf? or blog?)
      errors.add(:parent_id, "main pages can only contain leaf or blog pages")
    elsif parent.landing? and (leaf? or post?)
      errors.add(:parent_id, "landing pages cannot contain leaf or post pages")
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
  
  #searchable do
  #  text :name, :default_boost => 2
  #  text :text
  #end
  
  include ActionView::Helpers::SanitizeHelper

  def render_text
    #self.rendered_text = BlueCloth.new(self.text).to_html
    self.rendered_text = self.text # since we're using the YUI editor
    self.rendered_feature_text = BlueCloth.new(self.feature_text).to_html
    self.snippet_text = strip_tags(strip_links(self.rendered_text))
    self.snippet_feature_text =
      strip_tags(strip_links(self.rendered_feature_text))
  end
  
  def to_param
    url
  end
  
  def nav_context
    (self.parent and not self.parent.landing?) ? self.parent : self
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
  
  def includes?(page)
    children.each do |child|
      return true if page == child or child.includes?(page)
    end
    return false
  end
  
  def possible_parents
    # don't allow circular references
    Page.order('name').all.delete_if{|page|
      self.includes?(page) or page == self}
  end
  
  def possible_types
    if parent
      case parent.page_type
      when 'landing'
        ['main', 'landing', 'blog']
      when 'main'
        ['leaf', 'blog']
      when 'blog'
        ['post']
      when 'leaf', 'post'
        []
      end
    else
      Page::TYPES
    end
  end
  
  def possible_aspects
    case page_type
    when 'landing'
      %w(text photos videos audios contacts access feature)
    when 'main'
      %w(text photos videos audios documents forms
        contacts access feature podcast events)
    when 'leaf'
      %w(text photos videos audios documents forms
        contacts access feature events)
    when 'blog'
      %w(text contacts access feature podcast)
    when 'post'
      %w(text photos videos audios
        contacts access feature)
    end
  end
  
  def order_children(ids)
    result = true
    Page.transaction do
      tmp_children = Page.find(ids)
      ids.each_with_index do |id, i|
        child = tmp_children.detect{|c| id == c.id}
        child.index = i+1
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
          if (i+1) != child.index
            child.index = i+1
            child.save
          end
        end
      end
    end
  end
  
  def related_events(start_date=Date.today.beginning_of_day,
      stop_date=Date.today.beginning_of_day + 6.months)
    result =
      events.between(start_date, stop_date).order("start_at ASC").all
    children.each do |child|
      result += child.related_events(start_date, stop_date)
    end
    result
  end
  
  def categorized_events
    Event.categorize(events)
  end
  
  def landing?
    'landing' == page_type
  end
  
  def main?
    'main' == page_type
  end
  
  def leaf?
    'leaf' == page_type
  end
  
  def blog?
    'blog' == page_type
  end
  
  def post?
    'post' == page_type
  end
  
  private
  
  def extract_first_paragraph(str)
    return '' unless str
    matches = str.scan(/<p>(.*)<\/p>/)
    # TODO: improve this to not include styling from yui editor
    return (matches and matches[0] ? matches[0][0] : '')
  end
  
end
