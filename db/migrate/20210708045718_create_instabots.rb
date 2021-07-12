class CreateInstabots < ActiveRecord::Migration[6.0]
  def change
    create_table :instabots do |t|
      t.string :name
      t.string :password

      t.timestamps
    end
  end
end
