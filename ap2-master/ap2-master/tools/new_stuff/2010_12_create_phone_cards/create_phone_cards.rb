for cdr in CardCdr.find(:all, :select => "id, tmp_phone_id, card_id, src")
  card = cdr.card
  unless card.tmp_phones.find(:first, :conditions => {:id => cdr.tmp_phone_id})
    puts "cdr_id: #{cdr.id} src: #{cdr.src} " unless cdr.tmp_phone
    card.tmp_phones << cdr.tmp_phone if cdr.tmp_phone
  end
end
