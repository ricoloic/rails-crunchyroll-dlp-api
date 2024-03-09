class Orchestration < ApplicationRecord
  validates_presence_of :status

  belongs_to :episode, optional: false
  has_one :season, through: :episode
  has_one :show, through: :season

  has_many :execution_processes

  has_many :completed_execution_processes, -> { completed }, class_name: 'ExecutionProcess'
  has_many :not_completed_execution_processes, -> { not_completed }, class_name: 'ExecutionProcess'

  has_many :running_execution_processes, -> { running }, class_name: 'ExecutionProcess'
  has_many :not_running_execution_processes, -> { not_running }, class_name: 'ExecutionProcess'

  has_many :failed_execution_processes, -> { failed }, class_name: 'ExecutionProcess'
  has_many :not_failed_execution_processes, -> { not_failed }, class_name: 'ExecutionProcess'

  has_many :pending_execution_processes, -> { pending }, class_name: 'ExecutionProcess'
  has_many :not_pending_execution_processes, -> { not_pending }, class_name: 'ExecutionProcess'

  has_many :canceled_execution_processes, -> { canceled }, class_name: 'ExecutionProcess'
  has_many :not_canceled_execution_processes, -> { not_canceled }, class_name: 'ExecutionProcess'

  scope :running, -> { where(status: Constants::Statuses::RUNNING) }
  scope :pending, -> { where(status: Constants::Statuses::PENDING) }
  scope :completed, -> { where(status: Constants::Statuses::COMPLETED) }
  scope :failed, -> { where(status: Constants::Statuses::FAILED) }
  scope :canceled, -> { where(status: Constants::Statuses::CANCELED) }

  def running?
    status == Constants::Statuses::RUNNING
  end

  def pending?
    status == Constants::Statuses::PENDING
  end

  def completed?
    status == Constants::Statuses::COMPLETED
  end

  def failed?
    status == Constants::Statuses::FAILED
  end

  def canceled?
    status == Constants::Statuses::CANCELED
  end

  def last_execution_process
    execution_processes.last
  end

  def run_pending
    return unless self.completed?

    return unless Orchestration.running.count < 2

    orchestration = Orchestration.pending.first

    return if orchestration.blank?

    Functions::Orchestrations::Orchestrate.run(orchestration:)
  end

  def to_minimal_json_data
    {
      show: show.title,
      episode: episode.title,
      handle: last_execution_process&.handle,
      **attributes
    }
  end

  def to_json_data
    {
      show: show.attributes,
      season: season.attributes,
      episode: episode.attributes,
      processes: execution_processes.order(created_at: :desc).map(&:attributes),
      **attributes
    }
  end
end