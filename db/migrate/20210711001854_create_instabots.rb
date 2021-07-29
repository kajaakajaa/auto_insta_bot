class CreateInstabots < ActiveRecord::Migration[6.0]
  def change
    create_table :instabots do |t|
      t.string :user_name, null: false
      t.string :password, null: false
      t.references :user, foreign_key: true, null: false

      t.timestamps
    end
    add_column :instabots, :good, :boolean, default: false, null: false
    add_column :instabots, :follow, :boolean, default: false, null: false
    add_column :instabots, :unfollow, :boolean, default: false, null: false
    add_column :instabots, :hashtag, :string, null: false
  end
end
