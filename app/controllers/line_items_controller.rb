class LineItemsController < ApplicationController
  def create
    @voucher = Voucher.find(params[:voucher_id])
    @line_item = @voucher.line_items.create(line_item_params)

    @errors = @line_item.errors.full_messages.join("\n") unless @line_item.valid?
  end

  def destroy
    @line_item = LineItem.find(params[:id])

    @voucher = @line_item.voucher
    @line_item.destroy!
  end

  private
    def line_item_params
      params.require(:line_item).permit(:title, :amount, :purchase_date, :budget_type)
    end
end
