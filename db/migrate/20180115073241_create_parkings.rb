class CreateParkings < ActiveRecord::Migration[5.0]
  def change
    create_table :parkings do |t|
      t.belongs_to :spot, foreign_key: true
      t.text :name
      t.text :desc
      t.text :company
      t.text :minutes_to_walk
      t.integer :free
      t.integer :normal_capacity
      t.integer :large_capacity
      t.integer :specialize_capacity
      t.text :zip
      t.belongs_to :prefecture, foreign_key: true
      t.text :city
      t.text :address1
      t.text :address2
      t.text :email
      t.text :url
      t.text :info
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
