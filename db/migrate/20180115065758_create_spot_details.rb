class CreateSpotDetails < ActiveRecord::Migration[5.0]
  def change
    create_table :spot_details do |t|
      t.belongs_to :spot, foreign_key: true
      t.text :sub_name
      t.text :sub_name_spoken
      t.text :guide_reserve
      t.integer :guide_charge
      t.text :guide_tel
      t.text :guide_fax
      t.text :guide_email
      t.text :guide_url
      t.text :guide_info
      t.integer :wifi
      t.text :bus_pickup
      t.text :bus_frequency
      t.text :bus_operation_time
      t.text :bus_advance_notice
      t.integer :written_us
      t.integer :written_ch
      t.integer :written_zh
      t.integer :written_gr
      t.integer :written_fr
      t.integer :written_it
      t.integer :written_es
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
