module Functions
  module Executions
    class Base
      # @return [String]
      attr_accessor :status
      # @return [ExecutionProcess]
      attr_accessor :previous_execution
      # @return [String]
      attr_accessor :handle
      # @return [Episode]
      attr_accessor :episode
      # @return [Pathname]
      attr_accessor :dir
      # @return [String]
      attr_accessor :password
      # @return [String]
      attr_accessor :email
      # @return [String]
      attr_accessor :cookies
      # @return [Pathname]
      attr_accessor :season_dir
      # @return [String]
      attr_accessor :remote_url

      # @param previous_execution [ExecutionProcess, NilClass]
      # @param handle [String]
      # @param episode [Episode]
      def initialize(previous_execution: nil, handle:, episode:)
        @remote_url = ENV["REMOTE_URL"]
        @season_dir = Pathname.new("/").join("home").join("rico").join("personal").join("download-files").join(episode.season.show.title).join(episode.season.title)
        @dir = @season_dir.join(episode.title)
        @audio_dir = @dir.join("audio")
        @cookies = Pathname.new("/").join("home").join("rico").join("www.crunchyroll.com_cookies.txt").to_s
        @email = ENV["CRUNCHYROLL_EMAIL"]
        @password = ENV["CRUNCHYROLL_PASSWORD"]
        @status = Constants::ExecutionProcessStatuses::PENDING
        @previous_execution = previous_execution
        @handle = handle
        @episode = episode
      end

      def create_dirs
        FileUtils.makedirs(@season_dir)
        FileUtils.makedirs(@dir)
        FileUtils.makedirs(@audio_dir)
      end

      def start
        not_implemented __method__
      end

      def self.start
        not_implemented __method__
      end

      def run
        @status = Constants::ExecutionProcessStatuses::RUNNING
        execution_process.update!(status:)
      end

      def complete
        @status = Constants::ExecutionProcessStatuses::COMPLETED
        execution_process.update!(status:, completed_at: Time.now)
      end

      def fail
        @status = Constants::ExecutionProcessStatuses::FAILED
        execution_process.update!(status:)
      end

      def execution_process
        return @execution_process if @execution_process.present?

        @execution_process = ExecutionProcess.not_completed.find_by(
          previous_execution_process: @previous_execution,
          episode:
        )
        return @execution_process if @execution_process.present?

        @execution_process ||= ExecutionProcess.create!(
          status: @status,
          previous_execution_process: @previous_execution,
          handle:,
          completed_at: nil,
          episode:,
          output: output
        )
      end

      def output
        not_implemented __method__
      end

      def self.not_implemented(method)
        raise "method not implemented: #{method}"
      end
    end
  end
end