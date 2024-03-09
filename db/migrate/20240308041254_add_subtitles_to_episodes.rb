class AddSubtitlesToEpisodes < ActiveRecord::Migration[7.1]
  def change
    add_column :episodes, :subtitles, :json, default: []
  end
end
