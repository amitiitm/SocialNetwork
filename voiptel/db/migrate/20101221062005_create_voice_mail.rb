class CreateVoiceMail < ActiveRecord::Migration
  def self.up
    create_table "voicemail", :primary_key => "uniqueid", :force => true do |t|
      t.string   "context",         :limit => 80, :default => "default"
      t.string   "mailbox",         :limit => 80
      t.string   "password",        :limit => 80
      t.string   "fullname",        :limit => 80
      t.string   "email",           :limit => 80
      t.string   "pager",           :limit => 80
      t.string   "attach",          :limit => 3
      t.string   "attachfmt",       :limit => 10
      t.string   "serveremail",     :limit => 80
      t.string   "language",        :limit => 20
      t.string   "tz",              :limit => 30
      t.string   "deletevoicemail", :limit => 3
      t.string   "saycid",          :limit => 3
      t.string   "sendvoicemail",   :limit => 3
      t.string   "review",          :limit => 3
      t.string   "tempgreetwarn",   :limit => 3
      t.string   "operator",        :limit => 3
      t.string   "envelope",        :limit => 3
      t.string   "sayduration",     :limit => 3
      t.integer  "saydurationm"
      t.string   "forcename",       :limit => 3
      t.string   "forcegreetings",  :limit => 3
      t.string   "callback",        :limit => 80
      t.string   "dialout",         :limit => 80
      t.string   "exitcontext",     :limit => 80
      t.integer  "maxmsg"
      t.decimal  "volgain",         :precision => 5, :scale => 2
      t.string   "imapuser",        :limit => 80
      t.string   "imappassword",    :limit => 80
      t.datetime "stamp"
      t.integer  "account_id"
      t.integer  "subscriber_id"
      
      t.timestamps
    end
  end

  def self.down
    drop_table :voicemail
  end
end
