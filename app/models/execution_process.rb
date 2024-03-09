class ExecutionProcess < ApplicationRecord
  self.per_page = 25

  belongs_to :orchestration, optional: false

  belongs_to :previous_execution_process, class_name: 'ExecutionProcess', optional: true

  scope :completed, -> { where(status: Constants::Statuses::COMPLETED) }
  scope :not_completed, -> { where.not(completed) }

  scope :running, -> { where(status: Constants::Statuses::RUNNING) }
  scope :not_running, -> { where.not(running) }

  scope :failed, -> { where(status: Constants::Statuses::FAILED) }
  scope :not_failed, -> { where.not(failed) }

  scope :pending, -> { where(status: Constants::Statuses::PENDING) }
  scope :not_pending, -> { where.not(pending) }

  scope :canceled, -> { where(status: Constants::Statuses::CANCELED) }
  scope :not_canceled, -> { where.not(canceled) }

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
end