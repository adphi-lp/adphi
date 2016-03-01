class VouchersController < ApplicationController
  # CanCan strong_parameters workaround https://github.com/ryanb/cancan/issues/571
  before_filter do
    params[:voucher] &&= voucher_params
  end

  load_and_authorize_resource

  before_action :require_signed_in, only: [:index, :show, :create, :edit, :update, :dashboard]

  def index
    @voucher = Voucher.new(title: 'Voucher for ')

    @vouchers = current_brother.vouchers.all
  end

  # Currently, only the treasurer should be able to edit and update the voucher
  def edit
    @voucher = Voucher.find(params[:id])
  end

  def update
    @voucher = Voucher.find(params[:id])

    if @voucher.update(voucher_params)
      flash[:success] = "You've successfully modified the voucher."
      redirect_to @voucher
    else
      flash[:alert] = (["Can't modify voucher: "] + @voucher.errors.full_messages).join("\n")
      render 'edit'
    end
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

    # Send an email to the brother who created the voucher

    # NotificationsMailer.notification_email(
    #   @voucher.brother.email, 
    #   @voucher.notification_subject_publish(current_brother), 
    #   @voucher.notification_content_publish(current_brother), 
    #   url_for(@voucher)).deliver

    # For each officer in the voucher, send an email
    # @voucher.current_signatures.each do |sig|
    #   officer = sig.brother

    #   NotificationsMailer.notification_email(
    #     officer.email, 
    #     @voucher.notification_subject_publish(officer), 
    #     @voucher.notification_content_publish(officer), 
    #     url_for(@voucher)).deliver
    # end

    redirect_to voucher_path(@voucher), success: 'You have submitted this voucher. It can no longer be modified. '
  end

  def dashboard
    @vouchers = Voucher.all.to_a.select do |v|
      v.signatures.map(&:brother_id).include? current_brother.id
    end
  end

  def approve
    unless params[:check_number].present? && params[:paid_amount].present?
      redirect_to @voucher, flash: {alert: 'Invalid check number or amount to pay. '}
      return
    end

    @voucher.check_number = params[:check_number]
    @voucher.note = params[:note]
    @voucher.paid_amount = params[:paid_amount].to_f

    @voucher.save!

    Signature.find(params[:signature_id]).sign!

    redirect_to voucher_path(@voucher), flash: {success: 'You\'ve approved this voucher. '}
  end

  # Make a printable page of the voucher...
  def export
    @voucher = Voucher.find(params[:id])
    
    render 'export'
  end

  private
    def voucher_params
      params.require(:voucher).permit(:title, :owner_id, line_items_attributes: [:id, :title, :amount, :purchase_date, :budget_type])
    end
end
