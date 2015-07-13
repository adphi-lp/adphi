class VouchersController < ApplicationController
  before_action :require_signed_in, only: [:index, :show, :create, :edit, :update]

  def index
    @voucher = Voucher.new(title: 'Voucher for ')

    @vouchers = Voucher.all
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

  private
    def voucher_params
      params.require(:voucher).permit(:title)
    end
end
