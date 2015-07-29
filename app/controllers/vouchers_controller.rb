class VouchersController < ApplicationController
  before_action :require_signed_in, only: [:index, :show, :create, :edit, :update]

  def index
    @voucher = Voucher.new(title: 'Voucher for ')

    @vouchers = current_brother.vouchers.all
  end

  def show
    @voucher = Voucher.find(params[:id])

    @line_item = @voucher.line_items.new
    @receipt = @voucher.receipts.new
  end

  def create
    @voucher = Voucher.new(voucher_params)

    @voucher.brother = current_brother

    if @voucher.save
      flash[:success] = "You've successfully created a new voucher. "

      Shortlog.create_voucher(@voucher.brother, @voucher.id)

      redirect_to @voucher
    else
      flash[:alert] = (["Can't create voucher: "] + @voucher.errors.full_messages).join("\n")
      @vouchers = Voucher.all
      render 'index'
    end
  end

  def publish
    @voucher = Voucher.find(params[:id])

    @voucher.publish!
    redirect_to voucher_path(@voucher), success: 'You have submitted this voucher. It can no longer be modified. '
  end

  private
    def voucher_params
      params.require(:voucher).permit(:title)
    end
end
