require 'test_helper'

class AcquisitionTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end

  test "acquisition creation" do
    50.times do
        acquisition_attributes= {
            operator_id: Operator.select(:id).sample,
            company_id: Company.select(:id).sample,
            supplier_id: Supplier.select(:id).sample,
            invoice_number: (0...8).map{ (65 + rand(26)).chr }.join,
            allocation_attributes: {
                reason: (0...8).map{ (65 + rand(26)).chr }.join,
                destination_id: Placement.select(:id).sample,
                items_attributes: {
                    1 => { :plate => rand(1000).to_s, :brand => rand(1000).to_s, :serial => rand(1000).to_s, :value => rand(1000), :parkable_item_type => "Printer", :parkable_item_attributes => { :id => "" }},
                    2 => { :plate => rand(1000).to_s, :brand => rand(1000).to_s, :serial => rand(1000).to_s, :value => rand(1000), :parkable_item_type => "Screen", :parkable_item_attributes => { :id => "", :inches => 14 }},
                    3 => { :plate => rand(1000).to_s, :brand => rand(1000).to_s, :serial => rand(1000).to_s, :value => rand(1000), :parkable_item_type => "Printer", :parkable_item_attributes => { :id => "", :harddisk => "500GB", :memory => "2GB", :processor => "i3"}}
                },
                stock_item_groups_attributes: {
                    1 => {:stock_item_id => StockItem.select(:id).sample, :quantity => 1}
                }
            }
        }
        assert Acquisition.create acquisition_attributes
    end
  end
end
