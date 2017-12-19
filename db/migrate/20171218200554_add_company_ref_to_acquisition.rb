class AddCompanyRefToAcquisition < ActiveRecord::Migration
  def change
    add_reference :acquisitions, :company, index: true, foreign_key: true
  end
end
