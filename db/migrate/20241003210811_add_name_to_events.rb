class AddNameToEvents < ActiveRecord::Migration[7.1]
  def change
    add_column :events, :name, :string
  end
end
