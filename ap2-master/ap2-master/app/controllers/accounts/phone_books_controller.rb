class Accounts::PhoneBooksController < ApplicationController
  def index
    @account = Account.find(params[:account_id])
    @phone_books = PhoneBook.find(:all, :conditions => {:account_id => params[:account_id]}, :order => "freq DESC")
    resp
  end
  
  def edit
    @account = Account.find(params[:account_id])
    @phone_book = PhoneBook.find(params[:id])
    resp
  end
  
  def destroy
    @phone_book = PhoneBook.find(params[:id])
    @phone_book.destroy
  end
  
  def update
    @phone_book = PhoneBook.find(params[:id])
    if @phone_book.update_attributes(params[:phone_book])
      @success = true
    else
      @success = false
    end
    resp
  end
end
