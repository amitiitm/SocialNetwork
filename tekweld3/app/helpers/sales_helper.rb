module SalesHelper

  def find_order_stages(order_id)
    Sales::SalesOrder.find_by_sql("select case so.orderpickstatus_flag when 'Y' then 'NEW ORDER' else '' end as stage_code1,
                                                    case so.orderentrycomplete_flag when 'Y' then 'ENTRY COMPLETED' else '' end as stage_code2 ,
                                                    case so.orderqcstatus_flag  when 'Y' then 'QC COMPLETE ' else '' end  as stage_code3,
                                                    case so.artworkassigned_flag  when 'Y' then 'PROOF IN PROGRESS ' else '' end  as stage_code4,
                                                    case so.artworkcompleted_flag  when 'Y' then 'READY FOR INTERNAL PROOFING ' else '' end  as stage_code5,
                                                    case so.artworkreviewed_flag  when 'Y' then 'ARTWORK QC ' else '' end  as stage_code6,
                                                    case so.artworkapprovedbycust_flag  when 'A' then 'PROOF APPROVED ' else '' end  as stage_code7,
                                                    case sol.send_for_estimation_flag  when 'Y' then 'FILE SEND FOR STITCH ESTIMATION' else '' end  as stage_code8,
                                                    case sol.receive_stitch_estimation_flag  when 'Y' then 'DIGI ESTIMATION RECEIVED ' else '' end  as stage_code9,
                                                    case sol.customer_stitch_approval_flag  when 'Y' then 'STITCHES APPROVED BY CUSTOMER' else '' end  as stage_code10,
                                                    case sol.imposition_flag  when 'Y' then 'IMPOSITION COMPLETE' else '' end  as stage_code11,
                                                    case sol.film_flag  when 'Y' then 'FILM COMPLETE ' else '' end  as stage_code12,
                                                    case sol.print_flag  when 'Y' then 'PRINT COMPLETE' else '' end  as stage_code13,
                                                    case sol.cut_flag  when 'Y' then 'CUTTING COMPLETE ' else '' end  as stage_code14,
                                                    case sol.stitch_flag  when 'Y' then 'STITCH DONE ' else '' end  as stage_code15,
                                                    case sol.send_digitization_flag  when 'Y' then 'SENT DIGITIZING' else '' end  as stage_code16,
                                                    case sol.receive_digitization_flag  when 'Y' then 'DIGITIZED FILE RECEIVED' else '' end  as stage_code17
                                                    from sales_orders so
                                                    inner join sales_order_lines sol
                                                    on so.trans_no = sol.trans_no
                                                    where so.id = #{order_id} and sol.item_type='I' and sol.trans_flag = 'A' and so.trans_flag = 'A'")
  end
end
