class Production::ThreadColorCrud
  include General

  def self.list_thread_colors(doc)
    criteria = Setup::Criteria.fill_criteria_for_query(doc/:criteria)
    condition = "(company_id = #{criteria.company_id}) AND
                 (thread_company between '#{criteria.str1}' and '#{criteria.str2}' AND (0 =#{criteria.multiselect1.length} or thread_company in ('#{criteria.multiselect1}'))) AND
                 (thread_category between '#{criteria.str3}' and '#{criteria.str4}' AND (0 =#{criteria.multiselect2.length} or thread_category in ('#{criteria.multiselect2}'))) AND
                  trans_flag = 'A'"

    condition = convert_sql_to_db_specific(condition)
    Production::ThreadColor.find_by_sql ["select CAST((
                                  select(select *  from thread_colors
                                  where #{condition}
                                  FOR XML PATH('thread_color'), TYPE,ELEMENTS XSINIL
                                  )FOR XML PATH('thread_colors')) AS varchar(MAX)) as xmlcol"
    ]
  end

  def self.show_thread_color(id)
    Production::ThreadColor.find_all_by_id(id)
  end

  def self.create_thread_colors(doc)
    colors = []
    (doc/:thread_colors/:thread_color).each{|term_doc|
      color = create_thread_color(term_doc)
      colors <<  color if color
    }
    colors
  end

  def self.create_thread_color(doc)
    color = add_or_modify_thread_color(doc)
    return  if !color
    save_proc = Proc.new{
      if color.new_record?
        color.save!
      else
        color.save!
      end
    }
    color.save_transaction(&save_proc)
    return color
  end

  def self.add_or_modify_thread_color(doc)
    id =  parse_xml(doc/'id') if (doc/'id').first
    color = Production::ThreadColor.find_or_create(id)
    return if !color
    color.apply_attributes(doc)
    return color
  end
end

