class Setup::DashboardController < ApplicationController
  #  include General
  #  include ClassMethods
  require 'hpricot'

  def list_todays_shipments
    shipments = Setup::DashboardCrud.list_todays_shipments
    render :xml=>(shipments[0].xmlcol)
  end

  def list_tomorrows_shipments
    shipments = Setup::DashboardCrud.list_tomorrows_shipments
    render :xml=>(shipments[0].xmlcol)
  end

  def list_order_activity
    reports = Setup::DashboardCrud.list_order_activity
    render :xml=> reports[0].xmlcol
  end

  def list_production_activity
    reports = Setup::DashboardCrud.list_production_activity
    render :xml=>   reports[0].xmlcol
  end

  def list_order_types
    reports = Setup::DashboardCrud.list_order_types
    render :xml=>   reports[0].xmlcol
  end

  def list_rush_orders
    reports = Setup::DashboardCrud.list_rush_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_top10_orders
    reports = Setup::DashboardCrud.list_top10_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_top10_selling_items
    reports = Setup::DashboardCrud.list_top10_selling_items
    render :xml=>   reports[0].xmlcol
  end

  def list_generic_search
    doc = Hpricot::XML(request.raw_post)
    reports = Setup::DashboardCrud.list_generic_search(doc)
    render :xml=>   reports[0].xmlcol
  end

  def list_out_of_stock_orders
    reports = Setup::DashboardCrud.list_out_of_stock_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_out_of_stock_items
    reports = Setup::DashboardCrud.list_out_of_stock_items
    render :xml=>   reports[0].xmlcol
  end

  def list_artwork_receive_pending_orders
    reports = Setup::DashboardCrud.list_artwork_receive_pending_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_artwork_approval_pending_orders
    reports = Setup::DashboardCrud.list_artwork_approval_pending_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_payment_hold_orders
    reports = Setup::DashboardCrud.list_payment_hold_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_artwork_queries
    reports = Setup::DashboardCrud.list_artwork_queries
    render :xml=>   reports[0].xmlcol
  end

  def list_order_queries
    reports = Setup::DashboardCrud.list_order_queries
    render :xml=>   reports[0].xmlcol
  end

  def list_top10_customers
    reports = Setup::DashboardCrud.list_top10_customers
    render :xml=>   reports[0].xmlcol
  end

  def list_preproduction_not_approved_orders
    reports = Setup::DashboardCrud.list_preproduction_not_approved_orders
    render :xml=> reports[0].xmlcol
  end

  def list_embroidery_art_not_approved_orders
    reports = Setup::DashboardCrud.list_embroidery_art_not_approved_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_embroidery_sent_for_estimation_orders
    reports = Setup::DashboardCrud.list_embroidery_sent_for_estimation_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_embroidery_waiting_for_estimation_orders
    reports = Setup::DashboardCrud.list_embroidery_waiting_for_estimation_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_embroidery_stitch_not_approved_orders
    reports = Setup::DashboardCrud.list_embroidery_stitch_not_approved_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_embroidery_send_to_digitize_orders
    reports = Setup::DashboardCrud.list_embroidery_send_to_digitize_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_film_inbox_orders
    reports = Setup::DashboardCrud.list_film_inbox_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_direct_print_inbox_orders
    reports = Setup::DashboardCrud.list_direct_print_inbox_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_noresponse_paperproof_orders
    reports = Setup::DashboardCrud.list_noresponse_paperproof_orders
    render :xml=>   reports[0].xmlcol
  end

  def list_approved_coupons
    approved_coupons = Setup::DashboardCrud.list_approved_coupons
    render :xml => approved_coupons[0].xmlcol
  end

end