class CreateMessages < ActiveRecord::Migration[7.0]
  def change
    create_table :messages do |t|
      t.integer :send_id
      t.integer :receive_id
      t.text :content

      t.timestamps
    end
  end
end
