require "test_helper"

class UsersLoginTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "login with valid email/invalid password" do
    get login_path
    assert_template 'sessions/new'

    post login_path, params: { session: { email:    @user.email,
                                          password: "invalid" } }

    assert_response :unprocessable_entity
    assert_template 'sessions/new'
    assert_not flash.empty?
    get root_path
    assert flash.empty?
  end

  test "login with valid information" do
    post login_path, params: { session: { email:    @user.email,
                                          password: 'password' } }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end


#ログイン用のパスを開く
#新しいセッションのフォームが正しく表示されたことを確認する
#わざと無効なparamsハッシュを使ってセッション用パスにPOSTする
#新しいセッションのフォームが正しいステータスを返し、再度表示されることを確認する
#フラッシュメッセージが表示されることを確認する
#別のページ（Homeページなど） にいったん移動する
#移動先のページでフラッシュメッセージが表示されていないことを確認する
