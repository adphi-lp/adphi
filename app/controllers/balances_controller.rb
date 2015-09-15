class BalancesController < ApplicationController
  load_and_authorize_resource

  def update
    change = params[:change].to_f
    message = params[:message]

    @balance.value = @balance.value + change
    @balance.save

    Shortlog.balance(
      @balance.brother,
      current_brother,
      @balance.kind,
      change,
      message
    )

    @brother = @balance.brother
    @change = change

    respond_to do |format|
      format.js
    end
  end
end
