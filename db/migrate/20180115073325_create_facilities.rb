class CreateFacilities < ActiveRecord::Migration[5.0]
  def change
    create_table :facilities do |t|
      t.belongs_to :spot, foreign_key: true
      t.text :name
      t.text :quantity
      t.text :note
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
