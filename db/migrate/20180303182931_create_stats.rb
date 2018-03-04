class CreateStats < ActiveRecord::Migration[5.1]
  def change
    create_table :stats do |t|
      t.belongs_to :short_code, index: true
      t.string :user_agent

      t.timestamps
    end
  end
end
