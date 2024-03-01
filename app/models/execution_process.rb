class ExecutionProcess < ApplicationRecord
  self.per_page = 25

  belongs_to :episode
  belongs_to :previous_execution_process, class_name: 'ExecutionProcess', optional: true
  has_one :next_execution_process, class_name: 'ExecutionProcess', foreign_key: :previous_execution_process_id
  scope :not_completed, -> { where(completed_at: nil) }
  scope :completed, -> { where.not(ids: not_completed) }
  scope :not_failed, -> { where.not(status: Constants::ExecutionProcessStatuses::FAILED) }
  scope :pending, -> { where(status: Constants::ExecutionProcessStatuses::PENDING) }

  def running?
    status == Constants::ExecutionProcessStatuses::RUNNING
  end
end