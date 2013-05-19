# Methods added to this helper will be available to all templates in the application.

module ApplicationHelper

  def null_to_decimal(numeric_field)
    return 0 if numeric_field.nil?
    numeric_field.is_a?(String) ? numeric_field.to_d : numeric_field

  end

  def null_to_integer(numeric_field)
    return 0 if numeric_field.nil?
    numeric_field.is_a?(String) ? numeric_field.to_i : numeric_field

  end

  def null_to_blank(numeric_field)
    !numeric_field ? '' :  numeric_field
  end

  #  def date_format(date_field)
  #    date_field.to_time.strftime('%Y/%m/%d')  if date_field
  #  end

  def date_format(date_field)
    date_field.is_a?(ActiveSupport::TimeWithZone) ? date_field.time.strftime('%Y/%m/%d')  : date_field.to_time.strftime('%Y/%m/%d') if date_field
  end
  def format_column(column_value)
    column_value.is_a?(Float) ? null_to_decimal(column_value) : column_value
    column_value.is_a?(Time) ? date_format(column_value) : column_value
  end

  def convert_num_to_words(column_value)
    currency = column_value.to_s.split('.')
    @words=Linguistics::EN.numwords(currency[0]) + " dollars and " + Linguistics::EN.numwords(currency[1]) + " cents only"
    #  column_value.to_s.upto(column_value.to_s) { |number|  @words=Linguistics::EN.numwords(number) }
    return @words
  end

  def find_datetime_difference(start_date_time, end_date_time)
    @datetime_hash = Time.diff(start_date_time, end_date_time)
    return @datetime_hash
  end
  def parse_xml(objstring)
    objstring.first.innerHTML   if objstring.first
  end
end
