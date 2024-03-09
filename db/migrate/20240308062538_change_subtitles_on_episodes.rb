class ChangeSubtitlesOnEpisodes < ActiveRecord::Migration[7.1]
  def change
    change_column :episodes, :subtitles, :jsonb
  end
end
