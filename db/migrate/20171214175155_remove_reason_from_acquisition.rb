class RemoveReasonFromAcquisition < ActiveRecord::Migration
  def change
    remove_column :acquisitions, :reason, :string
  end
end
