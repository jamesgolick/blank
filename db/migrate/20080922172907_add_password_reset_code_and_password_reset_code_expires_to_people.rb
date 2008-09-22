class AddPasswordResetCodeAndPasswordResetCodeExpiresToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :password_reset_code, :string
    add_column :people, :password_reset_code_expires, :datetime
  end

  def self.down
    remove_column :people, :password_reset_code_expires
    remove_column :people, :password_reset_code
  end
end
