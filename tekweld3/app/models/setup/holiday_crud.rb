class Setup::HolidayCrud
  include General
  
  def self.list_holidays(doc)
    criteria = Setup::Criteria.fill_criteria(doc/:criteria)
    Setup::Holiday.find_by_sql ["select CAST( (select(select * from holidays
                                    where (holiday_date between ? and ? ) AND
                                    (event between ? and ? AND (0 =? or event in (?))) order by holiday_date
                                    FOR XML PATH('shipping'),type,elements xsinil)FOR XML PATH('shippings')) AS xml) as xmlcol
      " ,
      criteria.dt1,       criteria.dt2,
      criteria.str1,criteria.str2,criteria.multiselect1.length,criteria.multiselect1
    ]                                       
  end
  
  def self.show_holiday(holiday_id)
    Setup::Holiday.find_all_by_id(holiday_id)
  end
  
  def self.create_holidays(doc)
    holidays = [] 
    (doc/:holidaies/:holiday).each{|holiday_doc|
      holiday = create_holiday(holiday_doc)
      holidays <<  holiday if holiday
    }
    holidays
  end

  def self.create_holiday(doc)
    holiday = add_or_modify_holiday(doc) 
    return  if !holiday
    save_proc = Proc.new{
      holiday.save!  
    }
    holiday.save_transaction(&save_proc)
    return holiday
  end

  def self.add_or_modify_holiday(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first  
    holiday = Setup::Holiday.find_or_create(id) 
    return if !holiday
    holiday.apply_attributes(doc) 
    return holiday 
  end
end