module Logger
  
  def Logger.fill_log(trans_no,error_msg)
    error =  []
    error[1] = trans_no
    error[0] = error_msg
    error
  end
    
end
