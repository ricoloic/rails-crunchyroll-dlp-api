class CreateEpisodeLanguageUrls < ActiveRecord::Migration[7.1]
  def change
    create_table :episode_language_urls do |t|
      t.references :episode, foreign_key: true
      t.references :language, foreign_key: true
      t.boolean :is_video, null: false
      t.text :url, null: false

      t.timestamps
    end
  end
end
