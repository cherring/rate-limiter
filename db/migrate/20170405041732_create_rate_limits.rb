class CreateRateLimits < ActiveRecord::Migration[5.0]
  def change
    create_table :rate_limits do |t|
      t.string :ip_address
      t.datetime :requested_at

      t.timestamps
    end

    add_index :rate_limits, [:ip_address, :requested_at]
  end
end
