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

    if @voucher.publish!
      redirect_to voucher_path(@voucher), success: 'You have submitted this voucher. It can no longer be modified. '
    else
      redirect_to voucher_path(@voucher), alert: (["Can't create voucher: "] + @voucher.errors.full_messages).join("\n")
    end
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

  def regenerate_signatures
    @voucher = Voucher.find(params[:id])

    return redirect_to voucher_path(@voucher), flash: {alert: "You can only regenerate signatuers for vouchers that are currently pending officer signatures. "} unless @voucher.pending_officer_signatures?

    @voucher.regenerate_signatures!
    redirect_to voucher_path(@voucher), flash: {success: "You have successfully regenerated signatures for this voucher. "}
  end

  # Make a printable page of the voucher...
  def export
    @voucher = Voucher.find(params[:id])

    html = render_to_string(action: 'export', layout: false)
    voucher_pdf = PDFKit.new(html)

    combined_pdf = CombinePDF.parse(voucher_pdf.to_pdf)

    @voucher.receipts.each do |r|
      if r.content.content_type =~ /pdf/
        combined_pdf << CombinePDF.parse(Paperclip.io_adapters.for(r.content).read)
      else
        # It's image
        image_url = URI.join(request.url, r.content.url)
        image_pdf = PDFKit.new(render_to_string(action: 'export_image', layout: false, locals: {url: image_url}))
        combined_pdf << CombinePDF.parse(image_pdf.to_pdf)
      end
    end

    send_data(combined_pdf.to_pdf, type: 'application/pdf', filename: "voucher-#{@voucher.id}.pdf")
  end

  def destroy
    @voucher = Voucher.find(params[:id])

    return redirect_to voucher_path(@voucher), flash: {alert: "You can only delete vouchers that have not been submitted yet. "} unless @voucher.draft?

    @voucher.destroy!

    redirect_to vouchers_path, flash: {success: "You have successfully deleted the voucher titled \"#{@voucher.title}\". "}
  end

  private
    def voucher_params
      params.require(:voucher).permit(:title, :owner_id, line_items_attributes: [:id, :title, :amount, :purchase_date, :budget_type])
    end
end
