require File.dirname(__FILE__) + '/../../test_helper'

class Diamond::DiamondPacketTest < ActiveSupport::TestCase
  directory = File.join(File.dirname(__FILE__),"../../fixtures/diamond")
  Fixtures.create_fixtures(directory, "diamond_packets")
  
  def test_truth
    assert true
  end

  def test_should_create_packet
    packet = Diamond::DiamondPacket.new
    packet.packet_no='packet new'
    packet.diamond_lot_id = 1
    packet.company_id=1
    assert packet.save! , "#{packet.errors.full_messages.to_sentence}"
   end

  def test_should_not_allow_duplicate_code
    packet = Diamond::DiamondPacket.new
    packet.packet_no='ADP'
    packet.diamond_lot_id = 1
    packet.company_id=1
    assert !packet.save, "#{packet.errors.full_messages.to_sentence}"
  end  
  
end
