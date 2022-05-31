class AddImpressionsCountToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :impressions_count, :integer
  end
end
