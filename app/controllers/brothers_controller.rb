class BrothersController < ApplicationController
  def show
    @brother = Brother.find(params[:id])
    @logs = @brother.shortlogs.order('created_at DESC').map { |x| x.to_summary_entry }.compact
  end

  def index
    @brothers = Brother.current
  end
end
