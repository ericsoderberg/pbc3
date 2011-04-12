class Style < ActiveRecord::Base
  has_attached_file :banner, :styles => {
    :normal => '980x245',
    :thumb => '50x'
    }
  has_attached_file :feature_strip, :styles => {
      :normal => '200x200',
      :thumb => '50x'
    }
  has_attached_file :hero, :styles => {
      :normal => '980x445',
      :thumb => '50x25'
    }
  has_many :pages
  
  before_save :update_css
  
  def update_css
    self.css =<<CSS
  background-color: ##{gradient_lower_color.to_s(16)};
  background: -webkit-gradient(linear, 0% 0%, 0% 100%,
    from(#{"#%06x" % gradient_upper_color}), to(#{"#%06x" % gradient_lower_color}));
  background: -moz-linear-gradient(100% 100% 90deg,
    #{"#%06x" % gradient_upper_color}, #{"#%06x" % gradient_lower_color});
CSS
  end
end
