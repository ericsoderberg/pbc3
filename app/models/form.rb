class Form < ActiveRecord::Base
  belongs_to :page
  has_many :form_fields, :order => 'index ASC'
  
  validates :name, :presence => true
  
  def possible_pages
    Page.order('name')
  end
  
  def order_fields(ids)
    result = true
    FormField.transaction do
      tmp_fields = FormField.find(ids)
      ids.each_with_index do |id, i|
        field = tmp_fields.detect{|ff| id == ff.id}
        field.index = i+1
        # don't validate since it will fail as we haven't done them all yet
        result = false unless field.save(:validate => false)
      end
    end
    result
  end
  
end
