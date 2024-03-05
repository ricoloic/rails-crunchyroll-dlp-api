module Functions
  module Orchestrations
    class Orchestrate < Functions::Orchestrations::Base
      # @return [Episode]
      attr_accessor :episode
      # @return [Boolean]
      attr_accessor :initiated

      # @param episode [Episode]
      # @return [Functions::Orchestrations::Orchestrate]
      def initialize(episode:, orchestration: nil)
        @episode = episode
        @initiated = false
        @orchestration = orchestration
      end

      # @param episode [Episode]
      def self.process(episode:)
        new(episode:).init.process
      end

      def self.init(episode:)
        new(episode:).init
      end

      def init
        return self unless should_start_new?

        create_orchestration

        self
      end

      # @param orchestration [::Orchestration]
      def self.run(orchestration:)
        new(orchestration:, episode: orchestration.episode).run
      end

      def run
        return self if orchestration.blank? || orchestration.completed?

        process
      end

      def process
        return self if orchestration.blank?

        run_orchestration

        execution_process = Functions::Orchestrations::Executions::DownloadVideo
                              .process(orchestration: orchestration)
                              .execution_process
        return fail_orchestration if execution_process.failed?

        execution_process = Functions::Orchestrations::Executions::CompressVideo
                              .process(previous_execution: execution_process, orchestration: orchestration)
                              .execution_process
        return fail_orchestration if execution_process.failed?

        execution_process = Functions::Orchestrations::Executions::DownloadAudios
                              .process(previous_execution: execution_process, orchestration: orchestration)
                              .execution_process
        return fail_orchestration if execution_process.failed?

        execution_process = Functions::Orchestrations::Executions::MergeAudioStreams
                              .process(previous_execution: execution_process, orchestration: orchestration)
                              .execution_process
        return fail_orchestration if execution_process.failed?

        execution_process = Functions::Orchestrations::Executions::Metadata
                              .process(previous_execution: execution_process, orchestration: orchestration)
                              .execution_process
        return fail_orchestration if execution_process.failed?

        execution_process = Functions::Orchestrations::Executions::UploadToServer
                              .process(previous_execution: execution_process, orchestration: orchestration)
                              .execution_process
        return fail_orchestration if execution_process.failed?

        execution_process = Functions::Orchestrations::Executions::RemoveLocalFiles
                              .process(previous_execution: execution_process, orchestration: orchestration)
                              .execution_process
        return fail_orchestration if execution_process.failed?

        complete_orchestration
      end

      def orchestration
        @orchestration
      end

      private

      def run_orchestration
        orchestration.update(status: Constants::Statuses::RUNNING)
        self
      end

      def complete_orchestration
        orchestration.update(status: Constants::Statuses::COMPLETED)
        self
      end

      def fail_orchestration
        orchestration.update(status: Constants::Statuses::FAILED)
        self
      end

      def should_start_new?
        return true if previous_orchestration.nil?
        previous_orchestration&.failed?
      end

      # @return [Orchestration, NilClass]
      def previous_orchestration
        @previous_orchestration ||= episode.orchestration
      end

      def create_orchestration
        @orchestration = Orchestration.create(
          episode:,
          status: Constants::Statuses::PENDING
        )
      end
    end
  end
end