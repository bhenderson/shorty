class StatsController < ApplicationController
  def index
    @shorty = ShortCode.find_by!(code: params[:short_code_id])

    render json: @shorty.stats
  end
end
