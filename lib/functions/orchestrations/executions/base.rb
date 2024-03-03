require 'fileutils'

module Functions
  module Orchestrations
    module Executions
      class Base < Functions::Orchestrations::Base
        # @return [Orchestration]
        attr_accessor :orchestration
        # @return [ExecutionProcess]
        attr_accessor :previous_execution
        # @return [ExecutionProcess]
        attr_accessor :execution_process

        # @return [String]
        attr_accessor :password
        # @return [String]
        attr_accessor :email
        # @return [String]
        attr_accessor :remote_url

        # @param previous_execution [ExecutionProcess, NilClass]
        # @param orchestration [Orchestration]
        def initialize(previous_execution:, orchestration:)
          @orchestration = orchestration
          @previous_execution = previous_execution

          @remote_url = ENV["REMOTE_URL"]
          @email = ENV["CRUNCHYROLL_EMAIL"]
          @password = ENV["CRUNCHYROLL_PASSWORD"]
        end

        # @param previous_execution [ExecutionProcess, NilClass]
        # @param orchestration [Orchestration]
        def self.process(previous_execution: nil, orchestration:)
          new(previous_execution:, orchestration:).process
        end

        def process
          if create_dirs.run.execute
            complete
          else
            fail
          end
        end

        def run
          execution_process.update(status: Constants::Statuses::RUNNING)
          self
        end

        def complete
          execution_process.update(status: Constants::Statuses::COMPLETED, completed_at: Time.now)
          self
        end

        def fail
          execution_process.update(status: Constants::Statuses::FAILED)
          self
        end

        # @return [Boolean]
        def execute
          not_implemented __method__
        end

        def create_dirs
          FileUtils.makedirs(dir)
          FileUtils.makedirs(show_dir)
          FileUtils.makedirs(season_dir)
          FileUtils.makedirs(episode_dir)
          FileUtils.makedirs(audio_dir)
          self
        end

        def execution_process
          @execution_process ||= create_execution_process
        end

        def create_execution_process
          @execution_process = ExecutionProcess.create(
            status: Constants::Statuses::PENDING,
            previous_execution_process: @previous_execution,
            handle: handle,
            completed_at: nil,
            output: output,
            orchestration: @orchestration
          )
        end

        def episode
          @episode ||= @orchestration.episode
        end

        def dir
          @dir ||= Pathname.new("/").join("home").join("rico").join("personal").join("download-files")
        end

        def show_dir
          @show_dir ||= dir.join(episode.season.show.title)
        end

        def season_dir
          @season_dir ||= show_dir.join(episode.season.title)
        end

        def episode_dir
          @episode_dir ||= season_dir.join(episode.title)
        end

        def audio_dir
          @audio_dir ||= episode_dir.join("audio")
        end

        def cookie_filepath
          @cookie_filepath ||= Pathname.new("/").join("home").join("rico").join("www.crunchyroll.com_cookies.txt")
        end

        def handle
          not_implemented __method__
        end

        def output
          not_implemented __method__
        end
      end
    end
  end
end