class AddSlimcoreAuthorizer < ActiveRecord::Migration
  def self.up
    create_table :user_profiles do |t|
      t.integer :user_id
      t.string :role, :default => "customer"

      t.timestamps
    end

    create_table :lab_group_profiles do |t|
      t.integer :lab_group_id

      t.timestamps
    end
 end

  def self.down
    drop_table :user_profiles
    drop_table :lab_group_profiles
  end
end
