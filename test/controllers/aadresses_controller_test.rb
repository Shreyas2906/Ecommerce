require 'test_helper'

class AadressesControllerTest < ActionDispatch::IntegrationTest
  setup do
    @aadress = aadresses(:one)
  end

  test "should get index" do
    get aadresses_url
    assert_response :success
  end

  test "should get new" do
    get new_aadress_url
    assert_response :success
  end

  test "should create aadress" do
    assert_difference('Aadress.count') do
      post aadresses_url, params: { aadress: { country: @aadress.country, email: @aadress.email, line1: @aadress.line1, name: @aadress.name, phone: @aadress.phone, pincode: @aadress.pincode, state: @aadress.state, user_id: @aadress.user_id } }
    end

    assert_redirected_to aadress_url(Aadress.last)
  end

  test "should show aadress" do
    get aadress_url(@aadress)
    assert_response :success
  end

  test "should get edit" do
    get edit_aadress_url(@aadress)
    assert_response :success
  end

  test "should update aadress" do
    patch aadress_url(@aadress), params: { aadress: { country: @aadress.country, email: @aadress.email, line1: @aadress.line1, name: @aadress.name, phone: @aadress.phone, pincode: @aadress.pincode, state: @aadress.state, user_id: @aadress.user_id } }
    assert_redirected_to aadress_url(@aadress)
  end

  test "should destroy aadress" do
    assert_difference('Aadress.count', -1) do
      delete aadress_url(@aadress)
    end

    assert_redirected_to aadresses_url
  end
end
