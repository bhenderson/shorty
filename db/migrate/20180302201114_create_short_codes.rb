class CreateShortCodes < ActiveRecord::Migration[5.1]
  def change
    create_table :short_codes do |t|
      t.string :code, limit: 16
      t.string :url

      t.timestamps
    end
    add_index :short_codes, :code, unique: true
  end
end
