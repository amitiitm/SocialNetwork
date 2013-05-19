$new_inventory = true
$first = Card.first
$current = nil
Card.find_in_batches do |batch|
  batch.each do |card|
    if ($first.distribution_id == card.distribution_id) && ($first.value == card.value)
      $last = card
    else
      num_cards = $last.serial_number - $first.serial_number + 1
      puts "first: #{$first.serial} last: #{$last.serial} count: #{num_cards} #{($last.activated)? 'Activated' : 'Not Activated'} Value: #{$last.value}"
      inventory = CardsInventory.new(
        :value => $last.value,
        :num_cards => num_cards,
        :cards_start => $first.serial_number,
        :cards_end => $last.serial_number,
        :serial_start => $first.serial,
        :serial_end => $last.serial,
        :allocated => $last.activated
      )
      
      inventory.save
      if $last.distribution
        attributes = inventory.attributes
        attributes.delete("allocated")
        attributes.delete("created_at")
        attributes.delete("updated_at")
        attributes.delete("value")
        attributes = attributes.merge("distribution_id" => $last.distribution_id)
        
        di = DistributionInventory.new(attributes)
        inventory.distribution_inventory = di
      end
      
      $first = card
    end
  end
end

num_cards = $last.serial_number - $first.serial_number + 1
puts "first: #{$first.serial} last: #{$last.serial} count: #{num_cards} #{($last.activated)? 'Activated' : 'Not Activated'} Value: #{$last.value}"
inventory = CardsInventory.new(
  :value => $last.value,
  :num_cards => num_cards,
  :cards_start => $first.serial_number,
  :cards_end => $last.serial_number,
  :serial_start => $first.serial,
  :serial_end => $last.serial,
  :allocated => $last.activated
)

inventory.save
if $last.distribution
  attributes = inventory.attributes
  attributes.delete("allocated")
  attributes.delete("created_at")
  attributes.delete("updated_at")
  attributes.delete("value")
  attributes = attributes.merge("distribution_id" => $last.distribution_id)
  
  
  di = DistributionInventory.new(attributes)
  inventory.distribution_inventory = di
end