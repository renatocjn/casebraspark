class RenameTypeToKindInHelpDevice < ActiveRecord::Migration
  def change
    rename_column :help_devices, :type, :kind
  end
end
