class ReceiptsController < ApplicationController
  def create
    @voucher = Voucher.find(params[:voucher_id])
    @receipt = @voucher.receipts.create(receipts_params)

    @errors = @receipt.errors.full_messages unless @receipt.valid?
  end

  def destroy
    @receipt = Receipt.find(params[:id])

    @voucher = @receipt.voucher
    @receipt.destroy!
  end

  private
    def receipts_params
      params.require(:receipt).permit(:content)
    end
end
