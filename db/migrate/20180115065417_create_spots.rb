class CreateSpots < ActiveRecord::Migration[5.0]
  def change
    create_table :spots do |t|
      t.belongs_to :genre, nil:false, foreign_key: true
      t.text :name, nil: false
      t.text :name_spoken, nil:false
      t.text :body
      t.decimal :longitude, precision: 10, scale: 7
      t.decimal :latitude, precision: 10, scale: 7
      t.text :zip
      t.belongs_to :prefecture, nil:false, foreign_key: true
      t.text :city, nil:false
      t.text :address1
      t.text :address2
      t.text :tel
      t.text :fax
      t.text :email
      t.text :url
      t.text :active_term
      t.text :image_url
      t.text :image_copyright
      t.text :image_name
      t.text :image_spoken
      t.text :image_shooting_date
      t.text :ref_city_code, nil:false
      t.text :ref_name, nil:false
      t.text :ref_id, nil:false
      t.text :ref_sub_id, nil:false
      t.date :ref_updated_at, nil:false
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
