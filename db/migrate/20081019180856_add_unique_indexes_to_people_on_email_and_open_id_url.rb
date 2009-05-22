class AddUniqueIndexesToPeopleOnEmailAndOpenIdUrl < ActiveRecord::Migration
  def self.up
    add_index :people, :email,       :unique => true
    add_index :people, :open_id_url, :unique => true
  end

  def self.down
    remove_index :people, :email
    remove_index :people, :open_id_url
  end
end
