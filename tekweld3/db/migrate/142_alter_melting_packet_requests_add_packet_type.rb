class AlterMeltingPacketRequestsAddPacketType < ActiveRecord::Migration
  def self.up
    add_column :melting_packet_requests, :packet_type, :string ,:limit=>1, :default=>'W' # 'W' Request by Web, 'S' Request by Store
  end

  def self.down
    add_column :melting_packet_requests, :packet_type
  end
end
