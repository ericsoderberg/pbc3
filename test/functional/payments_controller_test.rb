require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  
  setup do
    @payment = payments(:retreat)
    @unpaid_filled_form = filled_forms(:unpaid_retreat_registration)
    # needed to work around devise problem
    @request.env['warden'] = TestWarden.new(@controller)
  end

  test "should get index" do
    sign_in users(:admin)
    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "should get new" do
    sign_in users(:admin)
    get :new, :form_id => @unpaid_filled_form.form.id
    assert_response :success
  end
  
  test "should get anonymous new" do
    get :new, :filled_form_key => @unpaid_filled_form.verification_key
    assert_response :success
  end
  
  test "shouldnt get anonymous new" do
    get :new, :form_id => @unpaid_filled_form.form.id
    assert_redirected_to root_url
  end
  
  test "shouldnt get anonymous new bad key" do
    get :new, :filled_form_key => @unpaid_filled_form.form.name
    assert_redirected_to root_url
  end

  test "should create payment" do
    sign_in users(:admin)
    assert_difference('Payment.count') do
      post :create, :payment => @payment.attributes,
        :filled_form_ids => [@unpaid_filled_form.id]
    end

    assert_not_nil assigns(:payment)
    assert_redirected_to payment_url(assigns(:payment),
      :verification_key => assigns(:payment).verification_key)
  end
  
  test "should create anonymous payment" do
    assert_difference('Payment.count') do
      post :create, :payment => @payment.attributes,
        :filled_form_ids => [@unpaid_filled_form.id],
        :filled_form_key => @unpaid_filled_form.verification_key
    end

    assert_not_nil assigns(:payment)
    assert_redirected_to payment_url(assigns(:payment),
      :verification_key => assigns(:payment).verification_key)
  end
  
  test "shouldnt create anonymous payment" do
    post :create, :payment => @payment.attributes,
      :filled_form_ids => [@unpaid_filled_form.id]
    assert_redirected_to root_url
  end

  test "should show payment" do
    sign_in users(:admin)
    get :show, :id => @payment.to_param
    assert_response :success
  end

  test "should get edit" do
    sign_in users(:admin)
    get :edit, :id => @payment.to_param
    assert_response :success
  end

  test "should update payment" do
    sign_in users(:admin)
    put :update, :id => @payment.to_param, :payment => @payment.attributes,
      :filled_form_ids => [@unpaid_filled_form.id]
    assert_not_nil assigns(:payment)
    assert_redirected_to payment_url(assigns(:payment))
  end

  test "should destroy payment" do
    sign_in users(:admin)
    assert_difference('Payment.count', -1) do
      delete :destroy, :id => @payment.to_param
    end

    assert_redirected_to payments_path
  end
end
