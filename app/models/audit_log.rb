class AuditLog < ActiveRecord::Base
  set_table_name 'audits'
  belongs_to :user
  belongs_to :auditable, :polymorphic => true
  
end
