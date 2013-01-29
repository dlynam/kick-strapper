class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string    :email
      t.string    :hashed_password, :limit => 64
      t.string    :username
      t.string    :referer
      t.string    :authorization_token
      t.string    :password_reset_token
      t.datetime  :password_reset_sent_at
      t.boolean   :enabled, :default => true
      t.boolean   :verified_email, :default => false
      t.integer   :fb_user_id, :limit => 8
      t.datetime  :created_at
    end
  end
end
