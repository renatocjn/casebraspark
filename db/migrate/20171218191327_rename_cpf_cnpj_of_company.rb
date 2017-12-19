class RenameCpfCnpjOfCompany < ActiveRecord::Migration
  def change
    rename_column :companies, :cpf_cpnj, :cnpj
  end
end
