module ApplicationHelper
   def user_signed_in?
    true
  end
  
  def DebugLog(mensagem)
    STDOUT << "\n #{DateTime.now.strftime("%d-%m-%Y %H:%M:%S")} ********************************* Logging: #{mensagem}\n\n"
  end
end
