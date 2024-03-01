module Constants
  module ExecutionProcessStatuses
    PENDING = "PENDING".freeze
    RUNNING = "RUNNING".freeze
    COMPLETED = "COMPLETED".freeze
    FAILED = "FAILED".freeze
  end

  module ExecutionProcessHandles
    DOWNLOAD_VIDEO = "DOWNLOAD_VIDEO".freeze
    DOWNLOAD_AUDIOS = "DOWNLOAD_AUDIOS".freeze
    COMPRESS_VIDEO = "COMPRESS_VIDEO".freeze
    MERGE_AUDIO_STREAMS = "MERGE_AUDIO_STREAMS".freeze
    METADATA = "METADATA".freeze
    REMOVE_LOCAL_FILES = "REMOVE_LOCAL_FILES".freeze
    UPLOAD_TO_SERVER = "UPLOAD_TO_SERVER".freeze
  end
end