class PaymentsController < ApplicationController
  before_filter :authenticate_user!, :except => [:new, :create, :edit, :update, :show, :notify]
  skip_before_filter :verify_authenticity_token, :only => [:notify]
  layout "administration", only: [:new, :create, :edit, :update]

  def index
    return unless administrator!
    @filter = {}
    @filter[:search] = params[:search]

    @payments = Payment
    @payments = @payments.search(@filter[:search]) if @filter[:search]
    @payments = @payments.order('created_at DESC')

    # get total count before we limit
    @count = @payments.count

    if params[:offset]
      @payments = @payments.offset(params[:offset])
    end
    @payments = @payments.limit(20)

    respond_to do |format|
      format.html # index.html.erb
      format.json { render :partial => "index" }
    end

    # if params[:state]
    #   @state = params[:state]
    # end
    #
    # if ('pending' == @state)
    #   @payments = Payment.where('sent_at IS NULL').
    #   order("created_at DESC")
    # elsif ('sent' == @state)
    #   @payments = Payment.where('sent_at IS NOT NULL AND ' +
    #     '(received_amount IS NULL AND received_at IS NULL)').
    #     order("created_at DESC")
    # elsif ('received' == @state)
    #   @payments = Payment.where('sent_at IS NOT NULL AND ' +
    #     '(received_amount > 0 OR received_at IS NOT NULL)').
    #     order("created_at DESC")
    # else
    #   @payments = Payment.order("created_at DESC")
    # end
    #
    # respond_to do |format|
    #   format.html # index.html.erb
    #   format.xml  { render :xml => @payments }
    # end
  end

  # def user_index
  #   @user = User.find(params[:id])
  #   @user = current_user unless current_user.administrator?
  #   @payments = @user.payments.to_a
  #
  #   respond_to do |format|
  #     format.html # user_index.html.erb
  #     format.xml  { render :xml => @filled_forms }
  #   end
  # end

  def show
    @payment = Payment.find(params[:id])
    return unless payment_authorized!

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  # def new
  #   @payment = Payment.new
  #   @payment.user = current_user
  #   @payment.method = Payment::METHODS.first
  #   @payment.sent_at = Date.today
  #   if params[:filled_form_key]
  #     @filled_form_key = params[:filled_form_key]
  #     @filled_form = FilledForm.where(:verification_key => params[:filled_form_key]).first
  #     unless @filled_form
  #       redirect_to root_url
  #       return
  #     end
  #     # if the form has already been payed, show the payment
  #     if @filled_form.payment
  #       redirect_to(payment_url(@filled_form.payment,
  #         :verification_key => @filled_form.payment.verification_key))
  #       return
  #     end
  #     @filled_forms = [@filled_form]
  #   elsif not current_user
  #     redirect_to root_url
  #     return
  #   elsif params[:form_id]
  #     @form = Form.find(params[:form_id])
  #     @filled_forms = @form.filled_forms.
  #       for_user(current_user).where(:payment_id => nil)
  #   else
  #     @filled_forms = current_user.filled_forms.includes(:form).
  #       where('forms.payable' => true, :payment_id => nil)
  #   end
  #
  #   @payment.amount = 0.to_money
  #   @filled_forms.each do |filled_form|
  #     @payment.filled_forms << filled_form
  #     @payment.amount += filled_form.payable_amount
  #   end
  #
  #   if @filled_forms.empty?
  #     redirect_to @form ? form_fills_path(@form) : root_path
  #     return false
  #   end
  #
  #   respond_to do |format|
  #     format.html # new.html.erb
  #     format.xml  { render :xml => @payment }
  #   end
  # end

  def edit
    @payment = Payment.find(params[:id])
    # if not current_user or not current_user.administrator?
    #   if params[:verification_key] != @payment.verification_key
    #     redirect_to root_url
    #     return
    #   end
    # end
    return unless payment_authorized!

    if params[:filled_form_key]
      @filled_form_key = params[:filled_form_key]
    end

    # @filled_form = @payment.filled_forms.first
    @filled_forms = FilledForm.possible_for_payment(@payment)
  end

  def create
    parse_date
    strip_admin_params unless current_user and current_user.administrator?
    @payment = Payment.new(payment_params)
    @payment.user = current_user
    params[:filled_form_ids].each do |filled_form_id|
      filled_form = FilledForm.find(filled_form_id)
      if (current_user and current_user.administrator?) or
        (current_user and filled_form.user == current_user) or
        (filled_form.verification_key == params[:filled_form_key])
        @payment.filled_forms << filled_form
      else
        redirect_to root_url
        return
      end
    end

    if @payment.filled_forms.empty?
      redirect_to
    end

    respond_to do |format|
      if @payment.save
        format.html {
          redirect_to(payment_url(@payment,
            :verification_key => @payment.verification_key),
          :notice => 'Payment indication was successfully submitted.') }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        if params[:filled_form_key]
          @filled_forms = [FilledForm.find_by(verification_key: params[:filled_form_key])]
        elsif not current_user
          redirect_to root_url
          return
        elsif params[:form_id]
          @form = Form.find(params[:form_id])
          @filled_forms = @form.filled_forms.
            for_user(current_user).where(:payment_id => nil)
        else
          @filled_forms = current_user.filled_forms.includes(:form).
            where('forms.payable' => true, :payment_id => nil)
        end

        @filled_forms.each do |filled_form|
          @payment.filled_forms << filled_form
          @payment.amount += filled_form.payable_amount
        end
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @payment = Payment.find(params[:id])
    return unless payment_authorized!
    parse_date
    strip_admin_params unless current_user and current_user.administrator?
    if params[:filled_form_ids]
      params[:filled_form_ids].each do |filled_form_id|
        unless @payment.filled_forms.exists?(:id => filled_form_id)
          @payment.filled_forms << FilledForm.find(filled_form_id)
        end
      end
    end

    respond_to do |format|
      if @payment.update_attributes(payment_params)
        format.html { redirect_to(payment_url(@payment,
              :verification_key => @payment.verification_key),
            :notice => 'Payment was successfully updated.') }
        format.xml  { head :ok }
        format.js  { render :nothing => true}
      else
        @filled_forms = FilledForm.possible_for_payment(@payment)
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
        format.js  { render :nothing => true}
      end
    end
  end

  def notify
    require "net/http"
    require "uri"

    @payment = Payment.find(params[:id])

    uri = URI.parse("#{Configuration.paypal_url}?cmd=_notify-validate")

    http = Net::HTTP.new(uri.host, uri.port)
    http.open_timeout = 60
    http.read_timeout = 60
    http.verify_mode = OpenSSL::SSL::VERIFY_NONE
    http.use_ssl = true
    response = http.post(uri.request_uri, request.raw_post,
      'Content-Length' => "#{request.raw_post.size}",
      'User-Agent' => "My custom user agent").body

    logger.info("Faulty paypal result: #{response}") unless ["VERIFIED", "INVALID"].include?(response)
    if "VERIFIED" == response
      @payment.method = 'PayPal'
      @payment.sent_at = Date.today
      @payment.received_amount = params[:payment_gross]
      @payment.received_at = Date.today
      @payment.save
    else
      logger.info("Invalid IPN: #{response}")
    end

    render :nothing => true
  end

  def destroy
    @payment = Payment.find(params[:id])
    params.delete(:verification_key)
    return unless payment_authorized!
    @filled_form = @payment.filled_forms.first
    user = @filled_form ? @filled_form.user : nil
    @payment.destroy

    respond_to do |format|
      format.html {
        if user != current_user or not @filled_form
          redirect_to(payments_url)
        else
          redirect_to(edit_form_fill_url(@filled_form.form, @filled_form))
        end
      }
      format.xml  { head :ok }
    end
  end

  private

  def payment_authorized!
    verification_key = params[:verification_key]
    if (current_user and current_user.administrator?) or
      (current_user and @payment.user == current_user) or
      (verification_key and @payment.verification_key == verification_key)
      return true
    end
    redirect_to root_url
    return false
  end

  def parse_date
    if params[:payment][:sent_at] and
      params[:payment][:sent_at].is_a?(String) and
      not params[:payment][:sent_at].empty?
      params[:payment][:sent_at] =
        Date.parse_from_form(params[:payment][:sent_at])
    end
    if params[:payment][:received_at] and
      params[:payment][:received_at].is_a?(String) and
      not params[:payment][:received_at].empty?
      params[:payment][:received_at] =
        Date.parse_from_form(params[:payment][:received_at])
    end
  end

  def strip_admin_params
    params[:payment].delete(:received_amount)
    params[:payment].delete(:received_at)
    params[:payment].delete(:received_notes)
  end

  def payment_params
    params.require(:payment).permit(:amount, :method,
      :received_amount, :received_at, :received_by, :received_notes,
      :notes, :sent_at, :verification_key)
  end

end
