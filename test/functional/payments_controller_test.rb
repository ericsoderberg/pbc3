require 'test_helper'

class PaymentsControllerTest < ActionController::TestCase
  
  setup do
    @payment = payments(:retreat)
    @unpaid_filled_form = filled_forms(:unpaid_retreat_registration)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:payments)
  end

  test "should get new" do
    get :new, :form_id => @unpaid_filled_form.form.id
    assert_response :success
  end

  test "should create payment" do
    assert_difference('Payment.count') do
      post :create, :payment => @payment.attributes,
        :filled_form_ids => [@unpaid_filled_form.id]
    end

    assert_not_nil assigns(:payment)
    assert_redirected_to payment_url(assigns(:payment))
  end

  test "should show payment" do
    get :show, :id => @payment.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @payment.to_param
    assert_response :success
  end

  test "should update payment" do
    put :update, :id => @payment.to_param, :payment => @payment.attributes,
      :filled_form_ids => [@unpaid_filled_form.id]
    assert_not_nil assigns(:payment)
    assert_redirected_to payment_url(assigns(:payment))
  end

  test "should destroy payment" do
    assert_difference('Payment.count', -1) do
      delete :destroy, :id => @payment.to_param
    end

    assert_redirected_to payments_path
  end
end
