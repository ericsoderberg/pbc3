class Page < ActiveRecord::Base
  before_save :render_text
  acts_as_url :name
  
  has_attached_file :text_image, :styles => {
      :normal => '120x',
      :thumb => '50x'
    }
  
  belongs_to :style
  has_many :notes, :order => 'created_at DESC'
  has_many :photos
  has_many :videos
  has_many :documents
  has_many :events, :order => 'start_at ASC' do
    def find_future(date=Date.today)
      find(:all, :conditions => ["start_at >= ?", date])
    end
    def find_next(date=Date.today)
      future_events = find_future(date)
      future_events.select do |e|
        # reject if there's an earlier similar one
        not e.master_id or not future_events.detect do |e2|
          ((e2.master_id == e.master_id or e2.id == e.master_id) and
          e2.start_at < e.start_at)
        end
      end
    end
    def find_masters(date=Date.today)
      find(:all, :conditions => "master_id IS NULL")
    end
  end
  has_one :group
  belongs_to :parent, :class_name => 'Page'
  has_many :children, :class_name => 'Page', :foreign_key => :parent_id
  has_many :contacts
  has_many :contact_users, :through => :contacts, :source => :user
  has_many :authorizations
  
  validates_presence_of :name
  validates_uniqueness_of :feature_index,
    :unless => Proc.new{|p| not p.feature_index}
    
  before_validation do
    if featured and feature_index
      # make sure peers have lower indexes
      Page.where(['feature_index >= ?', feature_index]).all.each do |page2|
        page2.feature_index += 1
        page2.save
      end
    end
  end
  
  #searchable do
  #  text :name, :default_boost => 2
  #  text :text
  #end

  def render_text
    self.rendered_text = BlueCloth.new(self.text).to_html
    self.rendered_feature_text = BlueCloth.new(self.feature_text).to_html
    self.snippet_text = extract_first_paragraph(self.rendered_text)
    self.snippet_feature_text =
      extract_first_paragraph(self.rendered_feature_text)
  end
  
  def to_param
    url
  end
  
  def authorized?(user)
    return true unless self.private?
    return true if user and user.administrator?
    authorizations.each{|a| return true if user == a.user}
    return false
  end
  
  private
  
  def extract_first_paragraph(str)
    matches = str.scan(/<p>(.*)<\/p>/)
    return (matches and matches[0] ? matches[0][0] : '')
  end
  
end
