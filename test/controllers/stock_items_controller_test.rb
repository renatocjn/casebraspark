require 'test_helper'

class StockItemsControllerTest < ActionController::TestCase
  setup do
    @stock_item = stock_items(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:stock_items)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create stock_item" do
    assert_difference('StockItem.count') do
      post :create, stock_item: { acquisition_id: @stock_item.acquisition_id, long_description: @stock_item.long_description, serial_number: @stock_item.serial_number, short_description: @stock_item.short_description, stock_item_types_id: @stock_item.stock_item_types_id }
    end

    assert_redirected_to stock_item_path(assigns(:stock_item))
  end

  test "should show stock_item" do
    get :show, id: @stock_item
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @stock_item
    assert_response :success
  end

  test "should update stock_item" do
    patch :update, id: @stock_item, stock_item: { acquisition_id: @stock_item.acquisition_id, long_description: @stock_item.long_description, serial_number: @stock_item.serial_number, short_description: @stock_item.short_description, stock_item_types_id: @stock_item.stock_item_types_id }
    assert_redirected_to stock_item_path(assigns(:stock_item))
  end

  test "should destroy stock_item" do
    assert_difference('StockItem.count', -1) do
      delete :destroy, id: @stock_item
    end

    assert_redirected_to stock_items_path
  end
end
