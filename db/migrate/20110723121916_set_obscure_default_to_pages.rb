class SetObscureDefaultToPages < ActiveRecord::Migration
  def self.up
    change_column_default :pages, :obscure, false
  end

  def self.down
  end
end
