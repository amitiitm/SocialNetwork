module CardsHelper
  def formatted_serial(serial)
    "#{serial[0..1]}-#{serial[2..3]}-#{serial[4..-1]}"
  end
end
