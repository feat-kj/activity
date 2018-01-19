class CreateGenres < ActiveRecord::Migration[5.0]
  def change
    create_table :genres do |t|
      t.text :name, nil: false
      t.integer :parent_id, nil: false
      t.integer :enable, nil: false, default:1
      t.datetime :created_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
      t.datetime :updated_at, nil:false, default: -> {'CURRENT_TIMESTAMP'}
    end
  end

  def down
    # Genre.destory
  end
end
