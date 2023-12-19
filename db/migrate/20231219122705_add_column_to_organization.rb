class AddColumnToOrganization < ActiveRecord::Migration[5.2]
  def change
    add_column :organizations, :type_of_invoice, :string
  end
end
