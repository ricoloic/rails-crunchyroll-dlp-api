class RunOrchestrationJob < ApplicationJob
  queue_as :default

  def perform(orchestration:)
    Functions::Orchestrations::Orchestrate.run(orchestration:)
  end
end
