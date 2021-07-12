class CreateInstabots < ActiveRecord::Migration[6.0]
  def change
    create_table :instabots do |t|
      t.string :user_name, null: false
      t.string :password, null: false

      t.timestamps
    end
  end
end
