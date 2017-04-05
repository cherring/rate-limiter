class CreateRequests < ActiveRecord::Migration[5.0]
  def change
    create_table :requests do |t|
      t.string :ip_address
      t.datetime :requested_at

      t.timestamps
    end

    add_index :requests, [:ip_address, :requested_at]
  end
end
