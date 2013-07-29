require 'test_helper'

class AuditLogsControllerTest < ActionController::TestCase
=begin
  ###
  setup do
    @audit_log = audits(:one)
    sign_in users(:admin)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:audit_logs)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create audit_log" do
    assert_difference('AuditLog.count') do
      post :create, :audit_log => @audit_log.attributes
    end

    assert_redirected_to audit_log_path(assigns(:audit_log))
  end

  test "should show audit_log" do
    get :show, :id => @audit_log.to_param
    assert_response :success
  end

  test "should get edit" do
    get :edit, :id => @audit_log.to_param
    assert_response :success
  end

  test "should update audit_log" do
    put :update, :id => @audit_log.to_param, :audit_log => @audit_log.attributes
    assert_redirected_to audit_log_path(assigns(:audit_log))
  end

  test "should destroy audit_log" do
    assert_difference('AuditLog.count', -1) do
      delete :destroy, :id => @audit_log.to_param
    end

    assert_redirected_to audit_logs_path
  end
=end
end
