class ChaneNameOfHourOfItem < ActiveRecord::Migration[5.2]
  def change
    rename_column :items,:hours , :amountPaid
  end
end
