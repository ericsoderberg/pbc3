class FilledFieldOption < ActiveRecord::Base
  belongs_to :filled_field
  belongs_to :form_field_option
end
