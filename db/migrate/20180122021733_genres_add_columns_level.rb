class GenresAddColumnsLevel < ActiveRecord::Migration[5.0]
  def change
    add_column :genres, :level, :integer, nil: false
  end
  
end
