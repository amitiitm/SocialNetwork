class Reports::SalesController < ApplicationController
  def monthly_graph        
    @sales = OrderTransaction.sales_for_year(params[:year])
    @daily_average = OrderTransaction.daily_average_for_year(params[:year])
    @number_of_deposits = OrderTransaction.number_of_deposits_for_year(params[:year])
    resp    
  end    
end
