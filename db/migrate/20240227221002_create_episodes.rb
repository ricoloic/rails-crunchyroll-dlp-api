class CreateEpisodes < ActiveRecord::Migration[7.1]
  def change
    create_table :episodes do |t|
      t.references :season, foreign_key: true
      t.integer :position, null: false
      t.string :title, null: false
      t.text :thumbnail_url
      t.text :description

      t.timestamps
    end
  end
end
