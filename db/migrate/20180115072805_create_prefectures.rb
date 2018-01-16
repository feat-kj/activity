class CreatePrefectures < ActiveRecord::Migration[5.0]
  def change
    create_table :prefectures do |t|
      t.text :name, nil:false
      t.text :name_spoken, nil:false
    end
  end  
end
