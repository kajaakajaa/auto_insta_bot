class ChangeColumnToAllowNull < ActiveRecord::Migration[6.0]
  def up
    change_column :instabots, :user_name, :string, null: true
    change_column :instabots, :password, :string, null: true
  end
end
