class OrchestrationController < ApplicationController
  def all
    raw_data = request.raw_post
    data = JSON.parse(raw_data).deep_symbolize_keys

    statuses = data[:statuses]

    all_orchestrations = Orchestration
                       .select(:episode_id).distinct
                       .select('*')
                       .where(status: statuses)
                       .limit(100)
                       .order(updated_at: :desc)

    render json: all_orchestrations.map(&:to_minimal_json_data)
  end

  def by_id
    render json: Orchestration.find(by_id_params[:id]).to_json_data
  end

  def by_id_params
    params.permit(:id)
  end
end