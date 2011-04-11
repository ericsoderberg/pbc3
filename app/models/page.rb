class Page < ActiveRecord::Base
  before_save :render_text
  acts_as_url :name
  
  has_attached_file :text_image, :styles => {
      :normal => '120x',
      :thumb => '50x'
    }
  has_attached_file :feature_image, :styles => {
      :normal => '200x200',
      :thumb => '50x'
    }
  has_attached_file :hero_background, :styles => {
      :normal => '980x445',
      :thumb => '50x25'
    }
  
  belongs_to :page_banner
  has_many :notes, :order => 'created_at DESC'
  has_many :photos
  has_many :videos
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
  
  validates_presence_of :name
  
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
  
  private
  
  def extract_first_paragraph(str)
    matches = str.scan(/<p>(.*)<\/p>/)
    return (matches and matches[0] ? matches[0][0] : '')
  end
  
end
