class CreateSpotImages < ActiveRecord::Migration[5.0]
  def change
    create_table :spot_images do |t|
      t.belongs_to :spot, foreign_key: true
      t.text :file_name, nil: false
      t.text :copyright
      t.text :name
      t.text :spoken
      t.date :shooting_date
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
