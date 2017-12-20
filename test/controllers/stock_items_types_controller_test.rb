require 'test_helper'

class StockItemsTypesControllerTest < ActionController::TestCase
  setup do
    @stock_items_type = stock_items_types(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_items_types)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_items_type" do
    assert_difference('StockItemsType.count') do
      post :create, stock_items_type: { description: @stock_items_type.description }
    end

    assert_redirected_to stock_items_type_path(assigns(:stock_items_type))
  end

  test "should show stock_items_type" do
    get :show, id: @stock_items_type
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_items_type
    assert_response :success
  end

  test "should update stock_items_type" do
    patch :update, id: @stock_items_type, stock_items_type: { description: @stock_items_type.description }
    assert_redirected_to stock_items_type_path(assigns(:stock_items_type))
  end

  test "should destroy stock_items_type" do
    assert_difference('StockItemsType.count', -1) do
      delete :destroy, id: @stock_items_type
    end

    assert_redirected_to stock_items_types_path
  end
end
