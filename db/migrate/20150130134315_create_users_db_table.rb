class CreateUsersDbTable < ActiveRecord::Migration
  def up
		create_table :users do |t|
		t.string :username
		t.string :password
		t.string :accdetails
		t.string :email
		t.integer :vip
		t.integer :filecount
		t.datetime :created_at
		t.datetime :updated_at
		end
	end
	def down
		drop_table :users
	end
end
