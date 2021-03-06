require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest

	def setup
		@user = users(:george)
		@other_user = users(:archer)
	end

	test "should redirect index when not logged in" do
		get users_path
		assert_redirected_to login_url
	end
  
  test "should get new" do
    get signup_path
    assert_response :success
  end

  test "should redirect edit when not logged in" do
  	get edit_user_path(@user)
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  test "should redirect update when not logged in" do
  	patch user_path(@user), params: { user: { name: @user.name,
  		                                        email: @user.email } }
  	assert_not flash.empty?
  	assert_redirected_to login_url
  end

  test "should not allow the admin attribute to be edited via the web" do
    post login_path, params: { session: { email:    @other_user.email,
                                          password: "password" } }
    assert_not @other_user.admin?
    patch user_path(@other_user), params: {
                                    user: { password:              "",
                                            password_confirmation: "",
                                            admin: true } }
    assert_not @other_user.reload.admin?
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when logged in as a non-admin" do
    post login_path, params: { session: { email:    @other_user.email,
                                          password: "password" } }
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end
    assert_redirected_to root_url
  end
end
