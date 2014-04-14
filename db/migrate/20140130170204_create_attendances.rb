class CreateAttendances < ActiveRecord::Migration
  def change
    create_table :attendances do |t|
      t.integer :spot_id
      t.integer :lecture_id
      t.text :observation

      t.timestamps
    end

    add_index :attendances, [:spot_id, :lecture_id], unique: true
  end
end