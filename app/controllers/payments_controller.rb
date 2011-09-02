class PaymentsController < ApplicationController
  before_filter :authenticate_user!
  
  def index
    @payments = Payment.all

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => @payments }
    end
  end
  
  def user_index
    @user = User.find(params[:id])
    @user = current_user unless current_user.administrator?
    @payments = @user.payments.all

    respond_to do |format|
      format.html # user_index.html.erb
      format.xml  { render :xml => @filled_forms }
    end
  end

  def show
    @payment = Payment.find(params[:id])
    return unless payment_authorized!

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  def new
    @payment = Payment.new
    @payment.user = current_user
    @payment.method = Payment::METHODS.first
    @payment.sent_at = Date.today
    if params[:filled_form_id]
      @filled_form = FilledForm.find(params[:filled_form_id])
      @payment.filled_forms << @filled_form
      @payment.amount = @filled_form.payable_amount
      logger.info("!!! amount: #{@payment.amount}")
    end
    @filled_forms = current_user.filled_forms.includes(:form).
      where('forms.payable' => true, :payment_id => nil)

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @payment }
    end
  end

  def edit
    @payment = Payment.find(params[:id])
    @filled_form = @payment.filled_forms.first
    @filled_forms = current_user.filled_forms.includes(:form).
      where('forms.payable' => true, :payment_id => [nil, @payment.id])
    return unless payment_authorized!
  end

  def create
    parse_date
    @payment = Payment.new(params[:payment])
    @payment.user = current_user
    params[:filled_form_ids].each do |filled_form_id|
      @payment.filled_forms << FilledForm.find(filled_form_id)
    end
    @filled_form = @payment.filled_forms.first

    respond_to do |format|
      if @payment.save
        format.html { redirect_to(
          edit_form_fill_url(@filled_form.form, @filled_form),
          :notice => 'Payment was successfully created.') }
        format.xml  { render :xml => @payment, :status => :created, :location => @payment }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def update
    @payment = Payment.find(params[:id])
    return unless payment_authorized!
    parse_date
    @filled_form = @payment.filled_forms.first

    respond_to do |format|
      if @payment.update_attributes(params[:payment])
        format.html {
          if @payment.user != current_user
            redirect_to(payments_url,
              :notice => 'Payment was successfully updated.')
          else
            redirect_to(
              edit_form_fill_url(@filled_form.form, @filled_form),
              :notice => 'Payment was successfully updated.')
          end
        }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @payment.errors, :status => :unprocessable_entity }
      end
    end
  end

  def destroy
    @payment = Payment.find(params[:id])
    return unless payment_authorized!
    @payment.destroy

    respond_to do |format|
      format.html { redirect_to(payments_url) }
      format.xml  { head :ok }
    end
  end
  
  private
  
  def payment_authorized!
    if not current_user or
      (not current_user.administrator? and
        @payment.user != current_user)
      
      redirect_to root_url
      return false
    end
    return true
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
  
end
