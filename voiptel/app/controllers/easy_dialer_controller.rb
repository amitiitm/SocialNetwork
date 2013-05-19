class EasyDialerController < ApplicationController
  def view
    @phone_book = PhoneBook.find(:all, :conditions => {:account_id => params[:id]}, :order => "freq DESC")
  end

  def delete
    PhoneBook.find(params[:id]).delete
  end

end
