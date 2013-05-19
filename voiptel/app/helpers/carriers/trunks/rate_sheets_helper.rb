module Carriers::Trunks::RateSheetsHelper
  def rate_sheet_files(rs)
    files = rs.rate_sheet_files
    raw render :partial => "carriers/trunks/rate_sheets/rate_sheet_files", :locals => {:rate_sheet_files => files}
  end
  
  def rate_sheet_file_mapped(rsf)
    if rsf.mapped
      map = "Mapped"
      cls = "ajax nice-blue"
    else
      map = "Not Mapped"
      cls = "ajax red"
    end
    link_to(map, 
      carrier_trunk_rate_sheet_rate_sheet_file_path(rsf.rate_sheet.trunk.carrier, rsf.rate_sheet.trunk, rsf.rate_sheet, rsf),
      :class => cls,
      :update => "container"
    )
  end
  
  def rate_sheet_file_processed(rsf)
    if rsf.processed
      "Processed"
    else
      "Not Processed"
    end    
  end
  
  def rate_sheet_status(rs)
    rs = RateSheet.find(rs.id)
    if rs.processed
      active_not_active(rs.active)
    else
      if rs.mapped
        logger.info { "------------- RS: MAPPED" }
        raw link_to("Not Processed", carrier_trunk_rate_sheet_process_sheet_path(
            rs.trunk.carrier,
            rs.trunk,
            rs), :class => "ajax-post red"
        )
      else
        logger.info { "----------- NOT MAPPED" }
        "Not Mapped"
      end
    end
  end
end