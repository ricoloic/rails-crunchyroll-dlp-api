module Constants
  module Statuses
    PENDING = "PENDING".freeze
    RUNNING = "RUNNING".freeze
    COMPLETED = "COMPLETED".freeze
    FAILED = "FAILED".freeze
    CANCELED = "CANCELED".freeze
  end

  module Handles
    DOWNLOAD_VIDEO = "DOWNLOAD_VIDEO".freeze
    DOWNLOAD_AUDIOS = "DOWNLOAD_AUDIOS".freeze
    DOWNLOAD_SUBTITLES = "DOWNLOAD_SUBTITLES".freeze
    COMPRESS_VIDEO = "COMPRESS_VIDEO".freeze
    MERGE_AUDIO_STREAMS = "MERGE_AUDIO_STREAMS".freeze
    METADATA = "METADATA".freeze
    REMOVE_LOCAL_FILES = "REMOVE_LOCAL_FILES".freeze
    UPLOAD_TO_SERVER = "UPLOAD_TO_SERVER".freeze
  end
end