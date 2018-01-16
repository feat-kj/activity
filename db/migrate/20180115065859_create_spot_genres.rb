class CreateSpotGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :spot_genres do |t|
      t.references :spot, foreign_key: true
      t.references :genre, foreign_key: true
      t.integer :main, nil: false, default: 0
      t.integer :level, nil: false, default: 1
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
    add_index :spot_genres, [:spot_id, :genre_id], unique: true
  end
end
