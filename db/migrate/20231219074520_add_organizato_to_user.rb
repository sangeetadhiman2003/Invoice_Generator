class AddOrganizatoToUser < ActiveRecord::Migration[5.2]
  def change
    add_reference :users, :organization, foreign_key: true
  end
end
