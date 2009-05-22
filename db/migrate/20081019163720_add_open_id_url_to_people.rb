class AddOpenIdUrlToPeople < ActiveRecord::Migration
  def self.up
    add_column :people, :open_id_url, :string
  end

  def self.down
    remove_column :people, :open_id_url
  end
end
