class AuditLog < ActiveRecord::Base
  self.table_name = 'audits'
  belongs_to :user
  belongs_to :auditable, :polymorphic => true
  
  ###attr_protected :id
end
