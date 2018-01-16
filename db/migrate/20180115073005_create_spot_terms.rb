class CreateSpotTerms < ActiveRecord::Migration[5.0]
  def change
    create_table :spot_terms do |t|
      t.belongs_to :spot, foreign_key: true
      t.integer :status, nil:false, default:0
      t.text :season
      t.date :open_date
      t.date :close_date
      t.text :day_of_week
      t.text :hour
      t.text :info
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
