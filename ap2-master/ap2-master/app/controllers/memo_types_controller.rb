class MemoTypesController < ApplicationController
  def index
    @memo_types = MemoType.find(:all, :order => "memo_category_id asc")
    resp
  end

  def new
    @memo_type = MemoType.new
    resp
  end

  def edit
    @memo_type = MemoType.find(params[:id])
    resp
  end

  def create
    @memo_type = MemoType.new(params[:memo_type])
    @memo_type.save
  end
  
  def update
    @memo_type = MemoType.find(params[:id])
    @memo_type.update_attributes(params[:memo_type])
  end
  
  def destroy
    @memo_type = MemoType.find(params[:id]).destroy
  end
  
  def select_category
    @memo_types = MemoType.find(:all, :conditions => {:memo_category_id => params[:id]}, :order => "subject asc").map {|t| [t.subject, t.id]}
    
    resp
  end
  
end
