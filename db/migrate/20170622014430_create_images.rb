class CreateImages < ActiveRecord::Migration[5.1]
  def change
    create_table :images do |t|
      t.binary :data
      t.binary :analyzed_data
      t.string :description

      t.timestamps
    end
  end
end
