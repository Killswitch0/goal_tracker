class RenameUserGroupModelToGroupUser < ActiveRecord::Migration[7.0]
  def change
    rename_table :user_groups, :group_users
  end
end
