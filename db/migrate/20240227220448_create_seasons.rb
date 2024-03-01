class CreateSeasons < ActiveRecord::Migration[7.1]
  def change
    create_table :seasons do |t|
      t.references :show, foreign_key: true
      t.integer :position, null: false
      t.string :title, null: false

      t.timestamps
    end
  end
end
