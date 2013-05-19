class Accounts::Users::PhonesController < ApplicationController
  layout nil
  def destroy
    @phone = Phone.find(params[:id])
  end

end
