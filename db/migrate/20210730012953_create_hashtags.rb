class CreateHashtags < ActiveRecord::Migration[6.0]
  def change
    create_table :hashtags do |t|
      t.string :hashtag
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
    change_column :hashtags, :hashtag, :string, null: false
    add_column :hashtags, :number, :integer, default: 50, null: false
  end
end
