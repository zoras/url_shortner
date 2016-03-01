require 'test_helper'

class ShortUrlsControllerTest < ActionController::TestCase
  setup do
    @short_url = short_urls(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:short_urls)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create short_url" do
    assert_difference('ShortUrl.count') do
      post :create, short_url: { long_url: @short_url.long_url }
    end

    assert_redirected_to short_url_path(assigns(:short_url))
  end

  test "should show short_url" do
    get :show, id: @short_url
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @short_url
    assert_response :success
  end

  test "should update short_url" do
    patch :update, id: @short_url, short_url: { long_url: @short_url.long_url }
    assert_redirected_to short_url_path(assigns(:short_url))
  end

  test "should destroy short_url" do
    assert_difference('ShortUrl.count', -1) do
      delete :destroy, id: @short_url
    end

    assert_redirected_to short_urls_path
  end
end
