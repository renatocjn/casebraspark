class RemoveOperatorRefFromAcquisition < ActiveRecord::Migration
  def change
    remove_column :acquisitions, :operator_id
  end
end
