class CreateSpotDescriptions < ActiveRecord::Migration[5.0]
  def change
    create_table :spot_descriptions do |t|
      t.belongs_to :spot, foreign_key: true
      t.text :body
      t.integer :main, default: 0
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
