class CreateAccesses < ActiveRecord::Migration[5.0]
  def change
    create_table :accesses do |t|
      t.belongs_to :spot, foreign_key: true
      t.text :name
      t.text :type
      t.text :start
      t.text :arrived
      t.integer :total_time
      t.integer :total_charge
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end
end
